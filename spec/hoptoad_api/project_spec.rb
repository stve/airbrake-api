require 'spec_helper'

describe Hoptoad::Project do
  before(:all) do
    Hoptoad.account = 'myapp'
    Hoptoad.auth_token = 'abcdefg123456'
    Hoptoad.secure = false
  end

  it "should have correct projects path" do
    Hoptoad::Project.collection_path.should == "/data_api/v1/projects.xml"
  end

  it "should find projects" do
    projects = Hoptoad::Project.find(:all)
    projects.size.should == 4
    projects.first.id.should == '1'
    projects.first.name.should == 'Venkman'
  end

end