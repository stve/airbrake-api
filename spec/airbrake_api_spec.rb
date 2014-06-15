require 'spec_helper'

describe AirbrakeAPI do

  context "configuration" do
    before(:each) do
      AirbrakeAPI.reset
    end

    it "should allow setting of the account" do
      AirbrakeAPI.account = 'myapp'
      expect(AirbrakeAPI.account).to eq('myapp')
      expect(AirbrakeAPI.account_path).to eq('http://myapp.airbrake.io')
    end

    it "should allow setting of the auth token" do
      AirbrakeAPI.auth_token = '123456'
      expect(AirbrakeAPI.auth_token).to eq('123456')
    end

    it "should allow setting of ssl protocol" do
      AirbrakeAPI.secure = true
      expect(AirbrakeAPI.protocol).to eq('https')
    end

    it "should default to standard http" do
      expect(AirbrakeAPI.protocol).to eq('http')
    end

    it "should should implement #configure" do
      AirbrakeAPI.configure(:account => 'anapp', :auth_token => 'abcdefg', :secure => true)
      expect(AirbrakeAPI.protocol).to eq('https')
      expect(AirbrakeAPI.auth_token).to eq('abcdefg')
      expect(AirbrakeAPI.account).to eq('anapp')
      expect(AirbrakeAPI.account_path).to eq('https://anapp.airbrake.io')
    end

    it 'takes a block' do
      AirbrakeAPI.configure do |config|
        config.account = 'anapp'
        config.auth_token = 'abcdefghij'
        config.secure = true
      end

      expect(AirbrakeAPI.protocol).to eq('https')
      expect(AirbrakeAPI.auth_token).to eq('abcdefghij')
      expect(AirbrakeAPI.account).to eq('anapp')
    end
  end

  context "when using SSL" do
    before(:each) do
      AirbrakeAPI.configure(:account => 'sslapp', :auth_token => 'abcdefg123456', :secure => true)
    end

    it "should find an error if account is SSL enabled" do
      error = AirbrakeAPI::Error.find(1696170)
      expect(error.id).to eq(1696170)
    end

    it "should raise an exception if trying to access SSL enabled account with unsecure connection" do
      AirbrakeAPI.secure = false
      expect do
        AirbrakeAPI::Error.find(1696170)
      end.to raise_error(AirbrakeAPI::AirbrakeError)
    end
  end

  describe '#options' do
    it 'returns a Hash' do
      expect(AirbrakeAPI.options).to be_kind_of(Hash)
    end

    context 'when configured' do
      it 'returns a Hash based on the configuration' do
        AirbrakeAPI.configure(:account => 'anapp', :auth_token => 'abcdefg', :secure => true)

        expect(AirbrakeAPI.options[:auth_token]).to eq('abcdefg')
      end
    end
  end

  describe 'client delegation' do
    it 'delegates to a client' do
      error = AirbrakeAPI.error(1696170)
      expect(error.id).to eq(1696170)
    end
  end

end
