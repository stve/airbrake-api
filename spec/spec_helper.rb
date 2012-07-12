require 'simplecov'
SimpleCov.start do
  add_group 'Airbrake API', 'lib/airbrake-api'
  add_group 'Specs', 'spec'
end

require 'rspec'
require 'fakeweb'

require 'active_support'
require 'active_support/core_ext'
require 'i18n'
require 'airbrake'

require File.expand_path('../../lib/airbrake-api', __FILE__)

FakeWeb.allow_net_connect = false

DEFAULTS = {:content_type => "application/xml; charset=utf-8", :status => ["403", "Forbidden"]}

def fixture_request(verb, url, file)
  FakeWeb.register_uri(verb, url, DEFAULTS.merge(:response => File.join(File.dirname(__FILE__), 'fixtures', file)))
end

# errors
fixture_request :get, 'http://myapp.airbrake.io/errors.xml?auth_token=abcdefg123456', 'errors.xml'
fixture_request :get, "http://myapp.airbrake.io/errors.xml?auth_token=abcdefg123456&page=2", 'paginated_errors.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696170.xml?auth_token=abcdefg123456", 'individual_error.xml'
fixture_request :put, 'http://myapp.airbrake.io/errors/1696170.xml?auth_token=abcdefg123456', 'update_error.xml'

# notices
fixture_request :get, "http://myapp.airbrake.io/errors/1696170/notices.xml?auth_token=abcdefg123456", 'notices.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696170/notices.xml?auth_token=abcdefg123456&page=1", 'notices.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696170/notices.xml?page=1&auth_token=abcdefg123456", 'notices.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696170/notices.xml?auth_token=abcdefg123456&page=2", 'paginated_notices.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696170/notices/1234.xml?auth_token=abcdefg123456", 'individual_notice.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696170/notices/666.xml?auth_token=abcdefg123456", 'broken_notice.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696171/notices.xml?auth_token=abcdefg123456", 'notices.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696171/notices.xml?auth_token=abcdefg123456&page=1", 'notices.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696171/notices.xml?auth_token=abcdefg123456&page=2", 'notices.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696171/notices.xml?auth_token=abcdefg123456&page=3", 'paginated_notices.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696171/notices/1234.xml?auth_token=abcdefg123456", 'notices.xml'
fixture_request :get, "http://myapp.airbrake.io/errors/1696172/notices.xml?auth_token=abcdefg123456&page=1", 'unauthorized.xml'


# projects
fixture_request :get, "http://myapp.airbrake.io/data_api/v1/projects.xml?auth_token=abcdefg123456", 'projects.xml'

# ssl responses
fixture_request :get, "https://sslapp.airbrake.io/errors/1696170.xml?auth_token=abcdefg123456", 'individual_error.xml'
FakeWeb.register_uri(:get, "http://sslapp.airbrake.io/errors/1696170.xml?auth_token=abcdefg123456", DEFAULTS.merge(:body => " ", :status => ["403", "Forbidden"]))
