require 'spec_helper'

describe Hoptoad::Notice do
  before(:all) do
    Hoptoad.account = 'myapp'
    Hoptoad.auth_token = 'abcdefg123456'
    Hoptoad.secure = false
  end

  it "should find error notices" do
    notices = Hoptoad::Notice.find_by_error_id(1696170)
    notices.size.should == 30
    notices.first.id.should == 1234
  end

  it "should find all error notices" do
    notices = Hoptoad::Notice.find_all_by_error_id(1696170)
    notices.size.should == 42
  end

  it "should find all error notices with a page limit" do
    notices = Hoptoad::Notice.find_all_by_error_id(1696171, :pages => 2)
    notices.size.should == 60
  end

  it "yields batches" do
    batches = []
    notices = Hoptoad::Notice.find_all_by_error_id(1696171, :pages => 2) do |batch|
      batches << batch
    end
    notices.size.should == 60
    batches.map(&:size).should == [30,30]
  end

  it "should find individual notices" do
    Hoptoad::Notice.find(1234, 1696170).should_not == nil
  end

  it "should find a broken notices" do
    Hoptoad::Notice.find(666, 1696170).should_not == nil
  end
end
