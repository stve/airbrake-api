require 'test_helper'

class HoptoadTest < Test::Unit::TestCase

  context "configuration" do
    setup do
      Hoptoad.account = nil
      Hoptoad.auth_token = nil
      Hoptoad.secure = false
    end

    should "allow setting of the account" do
      Hoptoad.account = 'myapp'
      assert_equal Hoptoad.account, 'myapp'
      assert_equal Hoptoad.account_path, 'http://myapp.hoptoadapp.com'
    end

    should "allow setting of the auth token" do
      Hoptoad.auth_token = '123456'
      assert_equal Hoptoad.auth_token, '123456'
    end

    should "allow setting of ssl protocol" do
      Hoptoad.secure = true
      assert_equal Hoptoad.protocol, 'https'
    end

    should "default to standard http" do
      Hoptoad.secure = false
      assert_equal Hoptoad.protocol, 'http'
    end

    should "should implement #configure" do
      Hoptoad.configure(:account => 'anapp', :auth_token => 'abcdefg', :secure => true)
      assert_equal Hoptoad.protocol, 'https'
      assert_equal Hoptoad.auth_token, 'abcdefg'
      assert_equal Hoptoad.account, 'anapp'
      assert_equal Hoptoad.account_path, 'https://anapp.hoptoadapp.com'
    end
  end

  context "given a Hoptoad account & API key" do
    setup do
      Hoptoad.account = 'myapp'
      Hoptoad.auth_token = 'abcdefg123456'
      Hoptoad.secure = false
    end

    should "have correct collection path" do
      assert_equal "/errors.xml", Hoptoad::Error.collection_path
    end

    should "generate correct error path given an id" do
      assert_equal "/errors/1234.xml", Hoptoad::Error.error_path(1234)
    end

    should "have correct projects path" do
      assert_equal "/data_api/v1/projects.xml", Hoptoad::Project.collection_path
    end

    context "when finding errors" do

      should "find a page of the 30 most recent errors" do
        errors = Hoptoad::Error.find(:all)
        ordered = errors.sort_by(&:most_recent_notice_at).reverse
        assert_equal ordered, errors
        assert_equal errors.size, 30
      end

      should "paginate errors" do
        errors = Hoptoad::Error.find(:all, :page => 2)
        ordered = errors.sort_by(&:most_recent_notice_at).reverse
        assert_equal ordered, errors
        assert_equal errors.size, 2
      end

      should "find an individual error" do
        error = Hoptoad::Error.find(1696170)
        assert_equal error.action, 'index'
        assert_equal error.id, 1696170
      end

    end

    context "when finding notices" do

      should "find error notices" do
        notices = Hoptoad::Notice.find_by_error_id(1696170)
        assert_equal notices.size, 30
        assert_equal notices.first.id, 1234
      end

      should "find all error notices" do
        notices = Hoptoad::Notice.find_all_by_error_id(1696170)
        assert_equal notices.size, 42
      end

      should "find individual notices" do
        Hoptoad::Notice.find(1234, 1696170)
      end

    end

    context "when retrieving projects" do

      should "find projects" do
        projects = Hoptoad::Project.find(:all)
        assert_equal projects.size, 4
        assert_equal projects.first.id, '1'
        assert_equal projects.first.name, 'Venkman'
      end

    end

    context "when using SSL" do

      should "find an error if account is SSL enabled" do
        Hoptoad.secure = true
        Hoptoad.account = "sslapp"
        error = Hoptoad::Error.find(1696170)
        assert_equal error.id, 1696170
      end

      should "raise exception if trying to access SSL enabled account with unsecure connection" do
        Hoptoad.account = "sslapp"
        Hoptoad.secure = false
        assert_raise(Hoptoad::HoptoadError) do
          error = Hoptoad::Error.find(1696170)
        end
      end
    end

  end

end