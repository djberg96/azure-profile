class Subscription
  attr_accessor :subscription_id
  attr_accessor :subscription_name
  attr_accessor :management_certificate
  attr_accessor :default
  attr_accessor :registered_providers
  attr_accessor :environment_name
  attr_accessor :management_endpoint
  attr_accessor :source

  DEFAULT_MANAGEMENT_ENDPOINT = "https://management.core.windows.net"

  def initialize
    yield self if block_given?
    @management_endpoint ||= DEFAULT_MANAGEMENT_ENDPOINT
  end
end
