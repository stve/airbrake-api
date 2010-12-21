# Ruby lib for working with the Hoptoad API's XML interface.
# The first thing you need to set is the account name.  This is the same
# as the web address for your account.
#
#   Hoptoad.account = 'myaccount'
#
# Then, you should set the authentication token.
#
#   Hoptoad.auth_token = 'abcdefg'
#
# If no token or authentication info is given, a HoptoadError exception will be raised.
#
# If your account uses ssl then turn it on:
#
#   Hoptoad.secure = true
#
# For more details, check out the hoptoad docs at http://hoptoadapp.com/pages/api.
#
# Find errors
#
#   Errors are paginated. You get 25 at a time.
#   errors = Hoptoad::Error.find(:all)
#
#   with pagination:
#   Hoptoad::Error.find(:all, :params => { :page => 2 })
#
#   find individual error by ID
#   Hoptoad::Error.find(44)
#
# Find *all* notices by error_id
#
#   notices = Hoptoad::Notice.all(1234) # 1234 == error id
#
# Find notice by id + error_id
#
#   notice = Hoptoad::Notice.find(12345, 1234) # 12345 == notice id, 1234 == error id

module Hoptoad
  class Base
    include HTTParty
    format :xml

    private

    def self.setup
      base_uri Hoptoad.account_path
      default_params :auth_token => Hoptoad.auth_token

      check_configuration
    end

    def self.check_configuration
      raise HoptoadError.new('API Token cannot be nil') if default_options.nil? || default_options[:default_params].nil? || !default_options[:default_params].has_key?(:auth_token)
      raise HoptoadError.new('Account cannot be nil') unless default_options.has_key?(:base_uri)
    end

    def self.fetch(path, options)
      response = get(path, { :query => options })
      if response.code == 403
        raise HoptoadError.new('SSL should be enabled - use Hoptoad.secure = true in configuration')
      end

      Hashie::Mash.new(response)
    end

  end
end