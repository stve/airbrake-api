require 'spec_helper'

describe AirbrakeAPI do

  context "configuration" do
    before(:each) do
      AirbrakeAPI.reset
    end

    it "should allow setting of the account" do
      AirbrakeAPI.account = 'myapp'
      AirbrakeAPI.account.should == 'myapp'
      AirbrakeAPI.account_path.should == 'http://myapp.airbrakeapp.com'
    end

    it "should allow setting of the auth token" do
      AirbrakeAPI.auth_token = '123456'
      AirbrakeAPI.auth_token.should == '123456'
    end

    it "should allow setting of ssl protocol" do
      AirbrakeAPI.secure = true
      AirbrakeAPI.protocol.should == 'https'
    end

    it "should default to standard http" do
      AirbrakeAPI.protocol.should == 'http'
    end

    it "should should implement #configure" do
      AirbrakeAPI.configure(:account => 'anapp', :auth_token => 'abcdefg', :secure => true)
      AirbrakeAPI.protocol.should == 'https'
      AirbrakeAPI.auth_token.should == 'abcdefg'
      AirbrakeAPI.account.should == 'anapp'
      AirbrakeAPI.account_path.should == 'https://anapp.airbrakeapp.com'
    end
  end

  context "when using SSL" do
    before(:each) do
      AirbrakeAPI.configure(:account => 'sslapp', :auth_token => 'abcdefg123456', :secure => true)
    end

    it "should find an error if account is SSL enabled" do
      error = AirbrakeAPI::Error.find(1696170)
      error.id.should == 1696170
    end

    it "should raise an exception if trying to access SSL enabled account with unsecure connection" do
      AirbrakeAPI.secure = false
      lambda do
        AirbrakeAPI::Error.find(1696170)
      end.should raise_error(AirbrakeAPI::AirbrakeError)
    end
  end

end