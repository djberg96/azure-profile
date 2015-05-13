#########################################################
# azure_subscription_spec.rb
#
# Specs for the Azure::Profile::Subscription class.
#########################################################
require 'rspec/autorun'
require 'azure/profile'

describe "subscription" do
  before(:all) do
    @default_endpoint = "https://management.core.windows.net"
  end

  before(:each) do
    @sub = Azure::Profile::Subscription.new
  end

  it "has a subscription_id accessor" do
    @sub.should respond_to(:subscription_id)
    @sub.subscription_id.should be_nil
  end

  it "has a subscription_name accessor" do
    @sub.should respond_to(:subscription_name)
    @sub.subscription_name.should be_nil
  end

  it "has a management_certificate accessor" do
    @sub.should respond_to(:management_certificate)
    @sub.management_certificate.should be_nil
  end

  it "has a default accessor that defaults to false" do
    @sub.should respond_to(:default)
    @sub.default.should be_false
  end

  it "has a registered_providers accessor" do
    @sub.should respond_to(:registered_providers)
    @sub.registered_providers.should be_nil
  end

  it "has an environment_name accessor with a default value" do
    @sub.should respond_to(:environment_name)
    @sub.environment_name.should eq("AzureCloud")
  end

  it "has a management_endpoint accessor with a default value" do
    @sub.should respond_to(:management_endpoint)
    @sub.management_endpoint.should eq(@default_endpoint)
  end

  it "has a source accessor with a default value" do
    @sub.should respond_to(:source)
    @sub.source.should eq("ruby")
  end

  after(:each) do
    @sub = nil
  end

  after(:all) do
    @default_endpoint = nil
  end
end
