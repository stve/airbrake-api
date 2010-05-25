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

module Hoptoad
  class Base
    include HTTParty
    format :xml
    
    private
    
    def self.setup
      base_uri Hoptoad.account
      default_params :auth_token => Hoptoad.auth_token
      
      check_configuration
    end
    
    def self.check_configuration
      raise HoptoadError.new('API Token cannot be nil') if default_options.nil? || default_options[:default_params].nil? || !default_options[:default_params].has_key?(:auth_token)
      raise HoptoadError.new('Account cannot be nil') unless default_options.has_key?(:base_uri)
    end

  end

  class Error < Base

    def self.find(*args)
      setup
      
      results = case args.first
        when Fixnum
          find_individual(args)
        when :all
          find_all(args)
        else
          raise HoptoadError.new('Invalid argument')
      end
      
      raise HoptoadError.new('No results found.') if results.nil?
      raise HoptoadError.new(results.errors.error) if results.errors
      
      results.group || results.groups
    end

    def self.update(error, options)
      setup
      
      self.class.put(collection_path, options)
    end

    private

    def self.find_all(args)
      options = args.extract_options!
      Hashie::Mash.new(get(collection_path, { :query => options }))
    end

    def self.find_individual(args)
      id = args.shift
      options = args.extract_options!
      hash = Hashie::Mash.new(response = get(error_path(id), { :query => options }))
      raise HoptoadError.new('SSL should be enabled - use Hoptoad.secure = true in configuration') if response.code == 403
      hash
    end

    def self.collection_path
      '/errors.xml'
    end

    def self.error_path(error_id)
      "/errors/#{error_id}.xml"
    end

  end

end