require 'spec_helper'

describe AirbrakeAPI::Project do
  before(:all) do
    AirbrakeAPI.account = 'myapp'
    AirbrakeAPI.auth_token = 'abcdefg123456'
    AirbrakeAPI.secure = false
  end

  it "should have correct projects path" do
    AirbrakeAPI::Project.collection_path.should == "/data_api/v1/projects.xml"
  end

  it "should find projects" do
    projects = AirbrakeAPI::Project.find(:all)
    projects.size.should == 4
    projects.first.id.should == '1'
    projects.first.name.should == 'Venkman'
  end

end