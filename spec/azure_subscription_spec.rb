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
    expect(@sub).to respond_to(:subscription_id)
    expect(@sub.subscription_id).to be_nil
  end

  it "has a subscription_name accessor" do
    expect(@sub).to respond_to(:subscription_name)
    expect(@sub.subscription_name).to be_nil
  end

  it "has a management_certificate accessor" do
    expect(@sub).to respond_to(:management_certificate)
    expect(@sub.management_certificate).to be_nil
  end

  it "has a default accessor that defaults to false" do
    expect(@sub).to respond_to(:default)
    expect(@sub.default).to be false
  end

  it "has a registered_providers accessor" do
    expect(@sub).to respond_to(:registered_providers)
    expect(@sub.registered_providers).to be_nil
  end

  it "has an environment_name accessor with a default value" do
    expect(@sub).to respond_to(:environment_name)
    expect(@sub.environment_name).to eq("AzureCloud")
  end

  it "has a management_endpoint accessor with a default value" do
    expect(@sub).to respond_to(:management_endpoint)
    expect(@sub.management_endpoint).to eq(@default_endpoint)
  end

  it "has a source accessor with a default value" do
    expect(@sub).to respond_to(:source)
    expect(@sub.source).to eq("ruby")
  end

  after(:each) do
    @sub = nil
  end

  after(:all) do
    @default_endpoint = nil
  end
end
