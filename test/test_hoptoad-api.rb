require 'test_helper'

class HoptoadTest < Test::Unit::TestCase

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

