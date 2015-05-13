# TODO: Move requires into methods on an as-needed basis
require 'json'
require 'nokogiri'
require 'openssl'
require 'base64'

require_relative 'profile/subscription'

module Azure
  class Profile
    # The path to your publishsettings file
    attr_accessor :settings_file

    # The path to your azureProfile.json file
    attr_accessor :json_file

    # Username for use with publishsettings file retrieval
    attr_accessor :username

    # Password for use with publishsettings file retrieval
    attr_accessor :password

    # A list of subscriptions associated with your profile
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
    #   # Pass a string or IO object
    #   prof = Azure::Profile.new(:content => IO.read("/Users/foo/azure.publishsettings"))
    #   prof = Azure::Profile.new(:content => File.open("/Users/foo/azure.publishsettings"))
    #
    def initialize(options = {})
      @settings_file = options[:settings_file]
      @json_file     = options[:json_file] || "~/.azure/azureProfile.json"
      @username      = options[:username]
      @password      = options[:password]
      @content       = options[:content]

      @subscriptions = []

      env = get_env_info

      @subscriptions << env if env

      if @settings_file
        @subscriptions << parse_settings(@settings_file)
      elsif @content
        @subscriptions << parse_settings(@content, false)
      else
        @subscriptions << parse_json_info
      end

      @subscriptions.flatten!
    end

    # Return the default subscription for the profile.
    def default_subscription
      @subscriptions.detect{ |s| s.default }
    end

    private

    # Look for relevant environment variables. If they're found, then
    # create a Subscription object using those.
    #
    def get_env_info
      sub = nil

      if ENV['AZURE_MANAGEMENT_CERTIFICATE'] ||
         ENV['AZURE_MANAGEMENT_ENDPOINT'] ||
         ENV['AZURE_SUBSCRIPTION_ID']
      then
        sub = Subscription.new
        sub.subscription_id = ENV['AZURE_SUBSCRIPTION_ID']
        sub.management_certificiate = ENV['AZURE_MANAGEMENT_CERTIFICATE']
        sub.management_endpoint = ENV['AZURE_MANAGEMENT_ENDPOINT']
        sub.source = "environment variables"
      end

      sub
    end

    # Parses a publishsettings file, or the raw XML.
    #
    def parse_settings(data, file = true)
      if file
        doc = Nokogiri::XML(File.open(data))
      else
        doc = Nokogiri::XML(data)
      end

      xml = doc.xpath("//PublishData//PublishProfile//Subscription")

      sub = Subscription.new

      sub.management_endpoint = xml.attribute('ServiceManagementUrl').value
      sub.subscription_id = xml.attribute('Id').value
      sub.subscription_name = xml.attribute('Name').value
      sub.default = true

      if @file
        sub.source = @settings_file
      else
        sub.source = 'external'
      end

      raw = xml.attribute('ManagementCertificate').value
      pkcs = OpenSSL::PKCS12.new(Base64.decode64(raw))
      sub.management_certificate = pkcs.certificate.to_pem + pkcs.key.to_pem

      sub
    end

    # Parses the Azure json profile file. This file should exist if you've
    # ever used the command line interface.
    #
    def parse_json_info
      data = IO.read(File.expand_path(@json_file))
      json = JSON.parse(data, :create_additions => false)

      array = []

      if json['subscriptions']
        json['subscriptions'].each{ |sub|
          array << Subscription.new do |s|
            s.source = @json_file
            s.subscription_id = sub['id']
            s.subscription_name = sub['name']
            s.default = sub['isDefault'] || false
            s.environment_name = sub['environmentName']
            s.management_endpoint = sub['managementEndpointUrl']
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
  dsub = prof.default_subscription

  require 'azure'

  # At the moment, the azure gem doesn't accept a string
  pem_file = File.expand_path('~/.azure/azure.pem')

  unless File.exists?(pem_file)
    File.open(pem_file, 'w'){ |fh| fh.write dsub.management_certificate }
  end

  Azure.configure do |config|
    config.subscription_id = dsub.subscription_id
    config.management_certificate = pem_file
    config.management_endpoint = dsub.management_endpoint
  end

  vms = Azure::VirtualMachineManagementService.new
  vm = vms.get_virtual_machine('win2k8-test1', 'win2k8-test1')

  p vm
end
