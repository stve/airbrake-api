require 'spec_helper'

describe AirbrakeAPI::Notice do
  before(:all) do
    AirbrakeAPI.account = 'myapp'
    AirbrakeAPI.auth_token = 'abcdefg123456'
    AirbrakeAPI.secure = false
  end

  it "should find error notices" do
    notices = AirbrakeAPI::Notice.find_by_error_id(1696170)
    notices.size.should == 42
    notices.first.id.should == 1234
  end

  it "should find all error notices" do
    notices = AirbrakeAPI::Notice.find_all_by_error_id(1696170)
    notices.size.should == 42
  end

  it "should find all error notices with a page limit" do
    notices = AirbrakeAPI::Notice.find_all_by_error_id(1696171, :pages => 2)
    notices.size.should == 60
  end

  it "yields batches" do
    batches = []
    notices = AirbrakeAPI::Notice.find_all_by_error_id(1696171, :pages => 2) do |batch|
      batches << batch
    end
    notices.size.should == 60
    batches.map(&:size).should == [30,30]
  end

  it "should find individual notices" do
    AirbrakeAPI::Notice.find(1234, 1696170).should_not == nil
  end

  it "should find a broken notices" do
    AirbrakeAPI::Notice.find(666, 1696170).should_not == nil
  end

  it 'defines the notices path' do
    AirbrakeAPI::Notice.all_path(1696170).should eq('/errors/1696170/notices.xml')
  end

  it 'defines the an individual notices path' do
    AirbrakeAPI::Notice.find_path(666, 1696170).should eq('/errors/1696170/notices/666.xml')
  end
end
