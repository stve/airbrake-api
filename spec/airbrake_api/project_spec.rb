require 'spec_helper'

describe Airbrake::Project do
  before(:all) do
    Airbrake.account = 'myapp'
    Airbrake.auth_token = 'abcdefg123456'
    Airbrake.secure = false
  end

  it "should have correct projects path" do
    Airbrake::Project.collection_path.should == "/data_api/v1/projects.xml"
  end

  it "should find projects" do
    projects = Airbrake::Project.find(:all)
    projects.size.should == 4
    projects.first.id.should == '1'
    projects.first.name.should == 'Venkman'
  end

end