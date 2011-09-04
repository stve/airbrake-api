require 'spec_helper'

describe Airbrake do

  context "configuration" do
    before(:each) do
      Airbrake.account = nil
      Airbrake.auth_token = nil
      Airbrake.secure = false
    end

    it "should allow setting of the account" do
      Airbrake.account = 'myapp'
      Airbrake.account.should == 'myapp'
      Airbrake.account_path.should == 'http://myapp.airbrakeapp.com'
    end

    it "should allow setting of the auth token" do
      Airbrake.auth_token = '123456'
      Airbrake.auth_token.should == '123456'
    end

    it "should allow setting of ssl protocol" do
      Airbrake.secure = true
      Airbrake.protocol.should == 'https'
    end

    it "should default to standard http" do
      Airbrake.protocol.should == 'http'
    end

    it "should should implement #configure" do
      Airbrake.configure(:account => 'anapp', :auth_token => 'abcdefg', :secure => true)
      Airbrake.protocol.should == 'https'
      Airbrake.auth_token.should == 'abcdefg'
      Airbrake.account.should == 'anapp'
      Airbrake.account_path.should == 'https://anapp.airbrakeapp.com'
    end
  end

  context "when using SSL" do
    before(:each) do
      Airbrake.configure(:account => 'sslapp', :auth_token => 'abcdefg123456', :secure => true)
    end

    it "should find an error if account is SSL enabled" do
      error = Airbrake::Error.find(1696170)
      error.id.should == 1696170
    end

    it "should raise an exception if trying to access SSL enabled account with unsecure connection" do
      Airbrake.secure = false
      lambda do
        Airbrake::Error.find(1696170)
      end.should raise_error(Airbrake::AirbrakeError)
    end
  end

end