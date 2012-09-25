require 'spec_helper'

describe AirbrakeAPI::Client do
  describe 'initialization' do
    before do
      @keys = AirbrakeAPI::Configuration::VALID_OPTIONS_KEYS
    end

    context "with module configuration" do
      before do
        AirbrakeAPI.configure do |config|
          @keys.each do |key|
            config.send("#{key}=", key)
          end
        end
      end

      after do
        AirbrakeAPI.reset
      end

      it "should inherit module configuration" do
        api = AirbrakeAPI::Client.new
        @keys.each do |key|
          api.send(key).should == key
        end
      end

      context "with class configuration" do

        before do
          @configuration = {
            :account => 'test',
            :auth_token => 'token',
            :secure => true,
            :connection_options => {},
            :adapter => :em_http,
            :user_agent => 'Airbrake API Tests'
          }
        end

        context "during initialization" do
          it "should override module configuration" do
            api = AirbrakeAPI::Client.new(@configuration)
            @keys.each do |key|
              api.send(key).should == @configuration[key]
            end
          end
        end

        context "after initilization" do
          it "should override module configuration after initialization" do
            api = AirbrakeAPI::Client.new
            @configuration.each do |key, value|
              api.send("#{key}=", value)
            end
            @keys.each do |key|
              api.send(key).should == @configuration[key]
            end
          end
        end
      end
    end
  end

  describe 'api requests'do
    before(:all) do
      options = { :account => 'myapp', :auth_token => 'abcdefg123456', :secure => false }
      AirbrakeAPI.configure(options)

      @client = AirbrakeAPI::Client.new
    end

    it "should fail with errors" do
      expect {
        @client.notices(1696172)
      }.to raise_error(AirbrakeAPI::AirbrakeError, /You are not authorized to see that page/)
    end

    describe '#deploys' do
      it 'returns an array of deploys' do
        @client.deploys('12345').should be_kind_of(Array)
      end

      it 'returns deploy data' do
        deploys = @client.deploys('12345')
        first_deploy = deploys.first

        first_deploy.rails_env.should eq('production')
      end

      it 'returns empty when no data' do
        @client.deploys('67890').should be_kind_of(Array)
      end
    end

    describe '#projects' do
      it 'returns an array of projects' do
        @client.projects.should be_kind_of(Array)
      end

      it 'returns project data' do
        projects = @client.projects
        projects.size.should == 4
        projects.first.id.should == '1'
        projects.first.name.should == 'Venkman'
      end
    end

    describe '#update' do
      it 'should update the status of an error' do
        error = @client.update(1696170, :group => { :resolved => true})
        error.resolved.should be_true
      end
    end

    describe '#errors' do
      it "should find a page of the 30 most recent errors" do
        errors = @client.errors
        ordered = errors.sort_by(&:most_recent_notice_at).reverse
        ordered.should == errors
        errors.size.should == 30
      end

      it "should paginate errors" do
        errors = @client.errors(:page => 2)
        ordered = errors.sort_by(&:most_recent_notice_at).reverse
        ordered.should == errors
        errors.size.should == 2
      end
    end

    describe '#error' do
      it "should find an individual error" do
        error = @client.error(1696170)
        error.action.should == 'index'
        error.id.should == 1696170
      end
    end

    describe '#notice' do
      it "finds individual notices" do
        @client.notice(1234, 1696170).should_not be_nil
      end

      it "finds broken notices" do
        @client.notice(666, 1696170).should_not be_nil
      end
    end

    describe '#notices' do
      it "finds all error notices" do
        notices = @client.notices(1696170)
        notices.size.should == 42
      end

      it "finds error notices for a specific page" do
        notices = @client.notices(1696170, :page => 1)
        notices.size.should == 30
        notices.first.id.should == 1234
      end

      it "finds all error notices with a page limit" do
        notices = @client.notices(1696171, :pages => 2)
        notices.size.should == 60
      end

      it "yields batches" do
        batches = []
        notices = @client.notices(1696171, :pages => 2) do |batch|
          batches << batch
        end
        notices.size.should == 60
        batches.map(&:size).should == [30,30]
      end

      it "can return raw results" do
        notices = @client.notices(1696170, :raw => true)
        notices[0].line.should == nil
        notices[0].id.should == 1234
      end
    end

    describe '#connection' do
      it 'returns a Faraday connection' do
        @client.send(:connection).should be_kind_of(Faraday::Connection)
      end
    end
  end

  describe '#url_for' do
    before(:all) do
      options = { :account => 'myapp', :auth_token => 'abcdefg123456', :secure => false }
      AirbrakeAPI.configure(options)

      @client = AirbrakeAPI::Client.new
    end

    it 'generates web urls for projects' do
      @client.url_for(:projects).should eq('http://myapp.airbrake.io/projects')
    end

    it 'generates web urls for deploys' do
      @client.url_for(:deploys, '2000').should eq('http://myapp.airbrake.io/projects/2000/deploys')
    end

    it 'generates web urls for errors' do
      @client.url_for(:errors).should eq('http://myapp.airbrake.io/errors')
    end

    it 'generates web urls for individual errors' do
      @client.url_for(:error, 1696171).should eq('http://myapp.airbrake.io/errors/1696171')
    end

    it 'generates web urls for notices' do
      @client.url_for(:notices, 1696171).should eq('http://myapp.airbrake.io/errors/1696171/notices')
    end

    it 'generates web urls for individual notices' do
      @client.url_for(:notice, 123, 1696171).should eq('http://myapp.airbrake.io/errors/1696171/notices/123')
    end

    it 'raises an exception when passed an unknown endpoint' do
      lambda { @client.url_for(:foo) }.should raise_error(ArgumentError)
    end
  end
end
