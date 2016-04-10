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

  it "has a VERSION constant set to the expected value" do
    expect(Azure::Profile::VERSION).to eq("1.0.2")
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
      expect(@profile).to respond_to(:settings_file)
      expect(@profile.settings_file).to eq(@settings_file)
    end

    it "sets the default subscription" do
      expect(@profile).to respond_to(:default_subscription)
      expect(@profile.default_subscription).to be_kind_of(Azure::Profile::Subscription)
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
      expect(@profile).to respond_to(:json_file)
      expect(@profile.json_file).to eq(@json_file)
    end

    it "sets the default subscription" do
      expect(@profile).to respond_to(:default_subscription)
      expect(@profile.default_subscription).to be_kind_of(Azure::Profile::Subscription)
    end

    after(:all) do
      @profile = nil
    end
  end
end
