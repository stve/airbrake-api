require 'simplecov'
SimpleCov.start do
  add_group 'Hoptoad API', 'lib/hoptoad-api'
  add_group 'Specs', 'spec'
end

require File.expand_path('../../lib/hoptoad-api', __FILE__)

require 'rspec'
require 'fakeweb'

FakeWeb.allow_net_connect = false

# errors
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'errors.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors.xml?auth_token=abcdefg123456&page=2", :response => File.join(File.dirname(__FILE__), 'fixtures', 'paginated_errors.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696170.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'individual_error.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])

# notices
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696170/notices.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696170/notices.xml?auth_token=abcdefg123456&page=1", :response => File.join(File.dirname(__FILE__), 'fixtures', 'notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696170/notices.xml?page=1&auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696170/notices.xml?auth_token=abcdefg123456&page=2", :response => File.join(File.dirname(__FILE__), 'fixtures', 'paginated_notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696170/notices/1234.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696171/notices.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696171/notices.xml?auth_token=abcdefg123456&page=1", :response => File.join(File.dirname(__FILE__), 'fixtures', 'notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696171/notices.xml?auth_token=abcdefg123456&page=2", :response => File.join(File.dirname(__FILE__), 'fixtures', 'notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696171/notices.xml?auth_token=abcdefg123456&page=3", :response => File.join(File.dirname(__FILE__), 'fixtures', 'paginated_notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696171/notices/1234.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'notices.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])


# projects
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/data_api/v1/projects.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'projects.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])

# ssl responses
FakeWeb.register_uri(:get, "http://sslapp.hoptoadapp.com/errors/1696170.xml?auth_token=abcdefg123456", :body => " ", :content_type => "application/xml; charset=utf-8", :status => ["403", "Forbidden"])
FakeWeb.register_uri(:get, "https://sslapp.hoptoadapp.com/errors/1696170.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'individual_error.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])