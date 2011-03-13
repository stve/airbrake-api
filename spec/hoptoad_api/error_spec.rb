require 'spec_helper'

describe Hoptoad::Error do
  before(:all) do
    Hoptoad.account = 'myapp'
    Hoptoad.auth_token = 'abcdefg123456'
    Hoptoad.secure = false
  end

  it "should have correct collection path" do
    Hoptoad::Error.collection_path.should == "/errors.xml"
  end

  it "should generate correct error path given an id" do
    Hoptoad::Error.error_path(1234).should == "/errors/1234.xml"
  end

  it "should find a page of the 30 most recent errors" do
    errors = Hoptoad::Error.find(:all)
    ordered = errors.sort_by(&:most_recent_notice_at).reverse
    ordered.should == errors
    errors.size.should == 30
  end

  it "should paginate errors" do
    errors = Hoptoad::Error.find(:all, :page => 2)
    ordered = errors.sort_by(&:most_recent_notice_at).reverse
    ordered.should == errors
    errors.size.should == 2
  end

  it "should find an individual error" do
    error = Hoptoad::Error.find(1696170)
    error.action.should == 'index'
    error.id.should == 1696170
  end

  it "should raise an error when not passed an id" do
    lambda do
      Hoptoad::Error.find
    end.should raise_error(Hoptoad::HoptoadError)
  end

end