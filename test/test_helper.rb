require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fakeweb'

require File.join(File.dirname(__FILE__), "..", "lib", "hoptoad-api")

FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'errors.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors.xml?auth_token=abcdefg123456&page=2", :response => File.join(File.dirname(__FILE__), 'fixtures', 'paginated_errors.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])
FakeWeb.register_uri(:get, "http://myapp.hoptoadapp.com/errors/1696170.xml?auth_token=abcdefg123456", :response => File.join(File.dirname(__FILE__), 'fixtures', 'individual_error.xml'), :content_type => "application/xml; charset=utf-8", :status => ["200", "OK"])