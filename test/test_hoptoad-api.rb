require 'test_helper'

class HoptoadTest < Test::Unit::TestCase

  context "given a Hoptoad account & API key" do
    setup do
      Hoptoad.account = 'myapp'
      Hoptoad.auth_token = 'abcdefg123456'
    end
    
    should "have correct collection path" do
      assert_equal "/errors.xml", Hoptoad::Error.collection_path
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
  end

end

