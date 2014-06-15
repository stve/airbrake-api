require 'spec_helper'

describe AirbrakeAPI::Notice do
  before(:all) do
    AirbrakeAPI.account = 'myapp'
    AirbrakeAPI.auth_token = 'abcdefg123456'
    AirbrakeAPI.secure = false
  end

  it "should find error notices" do
    notices = AirbrakeAPI::Notice.find_by_error_id(1696170)
    expect(notices.size).to eq(42)
    expect(notices.first.id).to eq(1234)
  end

  it "should find all error notices" do
    notices = AirbrakeAPI::Notice.find_all_by_error_id(1696170)
    expect(notices.size).to eq(42)
  end

  it "should fail with errors" do
    expect {
      AirbrakeAPI::Notice.find_all_by_error_id(1696172)
    }.to raise_error(AirbrakeAPI::AirbrakeError, /You are not authorized to see that page/)
  end

  it "should find all error notices with a page limit" do
    notices = AirbrakeAPI::Notice.find_all_by_error_id(1696171, :pages => 2)
    expect(notices.size).to eq(60)
  end

  it "yields batches" do
    batches = []
    notices = AirbrakeAPI::Notice.find_all_by_error_id(1696171, :pages => 2) do |batch|
      batches << batch
    end
    expect(notices.size).to eq(60)
    expect(batches.map(&:size)).to eq([30,30])
  end

  it "should find individual notices" do
    expect(AirbrakeAPI::Notice.find(1234, 1696170)).not_to eq(nil)
  end

  it "should find a broken notices" do
    expect(AirbrakeAPI::Notice.find(666, 1696170)).not_to eq(nil)
  end

  it 'defines the notices path' do
    expect(AirbrakeAPI::Notice.all_path(1696170)).to eq('/groups/1696170/notices.xml')
  end

  it 'defines the an individual notices path' do
    expect(AirbrakeAPI::Notice.find_path(666, 1696170)).to eq('/groups/1696170/notices/666.xml')
  end
end
