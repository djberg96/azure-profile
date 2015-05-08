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

    def initialize(options = {})
      @settings_file = options[:settings_file]
      @json_file     = options[:json_file] || "~/.azure/azureProfile.json"
      @username      = options[:username]
      @password      = options[:password]

      @subscriptions = parse_json_info
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
  p prof.subscriptions
end
