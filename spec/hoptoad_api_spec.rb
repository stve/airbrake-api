require 'spec_helper'

describe Hoptoad do

  context "configuration" do
    before(:each) do
      Hoptoad.account = nil
      Hoptoad.auth_token = nil
      Hoptoad.secure = false
    end

    it "should allow setting of the account" do
      Hoptoad.account = 'myapp'
      Hoptoad.account.should == 'myapp'
      Hoptoad.account_path.should == 'http://myapp.hoptoadapp.com'
    end

    it "should allow setting of the auth token" do
      Hoptoad.auth_token = '123456'
      Hoptoad.auth_token.should == '123456'
    end

    it "should allow setting of ssl protocol" do
      Hoptoad.secure = true
      Hoptoad.protocol.should == 'https'
    end

    it "should default to standard http" do
      Hoptoad.protocol.should == 'http'
    end

    it "should should implement #configure" do
      Hoptoad.configure(:account => 'anapp', :auth_token => 'abcdefg', :secure => true)
      Hoptoad.protocol.should == 'https'
      Hoptoad.auth_token.should == 'abcdefg'
      Hoptoad.account.should == 'anapp'
      Hoptoad.account_path.should == 'https://anapp.hoptoadapp.com'
    end
  end

  context "when using SSL" do
    before(:each) do
      Hoptoad.configure(:account => 'sslapp', :auth_token => 'abcdefg123456', :secure => true)
    end

    it "should find an error if account is SSL enabled" do
      error = Hoptoad::Error.find(1696170)
      error.id.should == 1696170
    end

    it "should raise an exception if trying to access SSL enabled account with unsecure connection" do
      Hoptoad.secure = false
      lambda do
        Hoptoad::Error.find(1696170)
      end.should raise_error(Hoptoad::HoptoadError)
    end
  end

end