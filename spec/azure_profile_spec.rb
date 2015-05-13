#########################################################
# azure_profile_spec.rb
#
# Specs for the Azure::Profile class.
#########################################################
require 'rspec/autorun'
require 'azure/profile'

describe "profile" do
  before(:all) do
    @json_file = File.join(File.dirname(__FILE__), 'azureProfile.json')
    @settings_file = File.join(File.dirname(__FILE__), 'azure.publishsettings')
  end

  after(:all) do
    @json_file = nil
    @settings_file = nil
  end

  context "using publishsettings file" do
    before(:all) do
      @profile = Azure::Profile.new(:settings_file => @settings_file)
    end

    it "has a settings_file accessor and it is set to the expected value" do
      @profile.should respond_to(:settings_file)
      @profile.settings_file.should eq(@settings_file)
    end

    it "sets the default subscription" do
      @profile.should respond_to(:default_subscription)
      @profile.default_subscription.should be_kind_of(Azure::Profile::Subscription)
    end

    after(:all) do
      @profile = nil
    end
  end

  context "using json file" do
    before(:all) do
      @profile = Azure::Profile.new(:json_file => @json_file)
    end

    it "has a json_file accessor and it is set to the expected value" do
      @profile.should respond_to(:json_file)
      @profile.json_file.should eq(@json_file)
    end

    it "sets the default subscription" do
      @profile.should respond_to(:default_subscription)
      @profile.default_subscription.should be_kind_of(Azure::Profile::Subscription)
    end

    after(:all) do
      @profile = nil
    end
  end
end
