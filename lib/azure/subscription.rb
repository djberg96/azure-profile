require 'json'
require 'nokogiri'
require 'openssl'
require 'net/http'

module Azure
  class Profile
    attr_accessor :settings_file
    attr_accessor :json_file
    attr_accessor :username
    attr_accessor :password

    attr_reader :subscriptions

    # Creates and returns a new Azure::Profile object. This will attempt to
    # gather subscription information based on the options you pass to it.
    #
    # If you pass no options, or the :json_file option, it will try to read
    # and parse your azureProfile.json file. By default it will look for this
    # file in $HOME/.azure, but you may specify a different directory.
    #
    # If you pass the :settings_file option, it will use nokogiri to parse
    # your publishsettings file. You must include the full path if you use
    # this option.
    #
    # If you pass the :username and :password options, then it will attempt
    # to download a publishsettings file from Microsoft to your $HOME/.azure
    # directory, and will then parse that.
    #
    # Examples:
    #
    #   require 'azure/subscription'
    #
    #   # Default to using json file.
    #   prof = Azure::Profile.new
    #   p prof.subscriptions
    #
    #   # Use a publishsettings file
    #   prof = Azure::Profile.new(:settings_file => "/Users/foo/azure.publishsettings")
    #   p prof.subscriptions
    #
    #   # Use your MS credentials
    #   prof = Azure::Profile.new(:username => 'foo', :password => 'xxxxx')
    #   p prof.subscriptions
    #
    def initialize(options = {})
      @settings_file = options[:settings_file]
      @json_file     = options[:json_file] || "~/.azure/azureProfile.json"
      @username      = options[:username]
      @password      = options[:password]

      @subscriptions = parse_json_info
    end

    # Return the default subscription for the profile.
    def default_subscription
      @subscriptions.detect{ |s| s.default }
    end

    class Subscription
      attr_accessor :subscription_id
      attr_accessor :subscription_name
      attr_accessor :management_certificate
      attr_accessor :default
      attr_accessor :registered_providers
      attr_accessor :environment_name
      attr_accessor :management_end_point

      def initialize
        yield self if block_given?
      end
    end

    private

    def parse_json_info
      data = IO.read(File.expand_path(@json_file))
      json = JSON.parse(data, :create_additions => false)

      array = []

      if json['subscriptions']
        json['subscriptions'].each{ |sub|
          array << Subscription.new do |s|
            s.subscription_id = sub['id']
            s.subscription_name = sub['name']
            s.default = sub['isDefault'] || false
            s.environment_name = sub['environmentName']
            s.management_end_point = sub['managementEndpointUrl']
            s.registered_providers = sub['registeredProviders']
            s.management_certificate = sub['managementCertificate']['cert'] +
              sub['managementCertificate']['key']
          end
        }
      end

      array
    end
  end
end

if $0 == __FILE__
  prof = Azure::Profile.new
  #p prof.subscriptions
  p prof.default_subscription.subscription_name
end
