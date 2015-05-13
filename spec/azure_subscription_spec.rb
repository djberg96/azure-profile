#########################################################
# azure_subscription_spec.rb
#
# Specs for the Azure::Profile::Subscription class.
#########################################################
require 'rspec/autorun'
require 'azure/profile'

describe "subscription" do
  before(:each) do
    @sub = Azure::Profile::Subscription.new
  end

  it "has a subscription_id accessor" do
    @sub.should respond_to(:subscription_id)
  end

  it "has a subscription_name accessor" do
    @sub.should respond_to(:subscription_name)
  end

  it "has a management_certificate accessor" do
    @sub.should respond_to(:management_certificate)
  end

  after(:each) do
    @sub = nil
  end
end
