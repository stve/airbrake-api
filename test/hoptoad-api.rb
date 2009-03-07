require 'test/unit'
require 'rubygems'
require 'shoulda'
require File.join(File.dirname(__FILE__), "..", "lib", "hoptoad-api")

class HoptoadTest < Test::Unit::TestCase

  context "given a Hoptoad account & API key" do
    setup do
      credentials_path = File.join(ENV['HOME'], ".hoptoad.yml")
      credentials = YAML::load_file(credentials_path)
      Hoptoad.account = credentials['account']
      Hoptoad.token   = credentials['token']
    end

    should "find a page of the 30 most recent errors" do
      errors  = Hoptoad::Error.find(:all)
      ordered = errors.sort_by(&:most_recent_notice_at).reverse
      assert_equal ordered, errors
      assert_equal 30, errors.size
    end

    should "have correct collection path" do
      assert_equal "/errors.xml", Hoptoad::Error.collection_path
    end
  end

end

