module Azure
  class Profile
    # A class that represents an invididual subscription with an Azure profile.
    class Subscription
      # Azure subscription ID.
      attr_accessor :subscription_id

      # Azure subscription name, e.g. "Free Trial"
      attr_accessor :subscription_name

      # Azure certificate, a combination of the cert + key
      attr_accessor :management_certificate

      # Returns whether or not this is a default subscription
      attr_accessor :default

      # An array of registered providers
      attr_accessor :registered_providers

      # Azure environment name, e.g. "AzureCloud"
      attr_accessor :environment_name

      # Azure endpoint. The default is https://management.core.windows.net
      attr_accessor :management_endpoint

      # The source of the subscription, e.g. "~/.azure/azureProfile.json"
      attr_accessor :source

      DEFAULT_MANAGEMENT_ENDPOINT = "https://management.core.windows.net"

      # Creates and returns a new Subscription object. If a block is given
      # then the object is yielded to the block.
      #
      # Example:
      #
      #   # These values are for demonstration purposes only
      #   Subscription.new do |s|
      #     s.subscription_id = 'abc-123-xyz'
      #     s.subscription_name = 'My Subscription'
      #     s.source = 'me'
      #     s.default = false
      #     s.management_certificate = generate_my_cert(Etc.getlogin)
      #     s.environment_name = 'MyEnvironment'
      #   end
      #
      # If no :management_endpoint is provided, then it will default to using
      # Subscription::DEFAULT_MANAGEMENT_ENDPOINT. If no :source is provided,
      # then it will default to 'ruby'. If no :default is provided, it will
      # default to false. If no :environment_name is provided, it will default
      # to 'AzureCloud'.
      #
      # There is no default for the :registered providers or
      # :management_certificate accessors. You must provide those. The certificate
      # should be a combination of the cert and key so that you can pass its value
      # directly to another interface, such as the azure gem.
      #
      # Note that you will not normally create Subscription objects directly.
      # The Azure::Profile class will generate them and pass them back to you.
      #
      def initialize
        yield self if block_given?

        @management_endpoint ||= DEFAULT_MANAGEMENT_ENDPOINT
        @source ||= 'ruby'
        @default ||= false
      end
    end
  end
end
