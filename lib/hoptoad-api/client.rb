# Ruby lib for working with the Hoptoad API's XML interface.  
# The first thing you need to set is the account name.  This is the same
# as the web address for your account.
#
#   Hoptoad.account = 'myaccount'
#
# Then, you should set the authentication token.
#
#   Hoptoad.token = 'abcdefg'
#
# If no token or authentication info is given, a HoptoadError exception will be raised.
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
  class Error
    include HTTParty
    format :xml
  
    # cattr_accessor :collection_path, :individual_collection_path
  
    @@collection_path = '/errors.xml'
    @@individual_collection_path = '/errors/'
  
    # def initialize
    #   self.class.base_uri "http://#{account}.hoptoadapp.com"
    #   self.class.default_params :auth_token => token
    # 
    # 
    # end
    
    def self.collection_path
      @@collection_path
    end
  
    def self.find(*args)
      base_uri Hoptoad.account
      default_params :auth_token => Hoptoad.auth_token
      
      check_configuration
    
      results = case args.first
        when Fixnum
          find_individual(args)
        when :all
          find_all(args)
        else
          raise HoptoadError.new('Invalid argument')
      end
      
      # puts results.inspect
    
      raise HoptoadError.new('No results found.') if results.nil?
      raise HoptoadError.new(results.errors.error) if results.errors
      
      results.group || results.groups
    end
  
    def self.update(error, options)
      check_configuration
    
      self.class.put("#{@collection_path}", options)
    end
  
    private
  
    def self.check_configuration
      raise HoptoadError.new('API Token cannot be nil') if default_options.nil? || default_options[:default_params].nil? || !default_options[:default_params].has_key?(:auth_token)
      raise HoptoadError.new('Account cannot be nil') unless default_options.has_key?(:base_uri)
    end
  
    def self.find_all(args)
      options = args.extract_options!
      Hashie::Mash.new(get("#{@@collection_path}", { :query => options }))
    end
  
    def self.find_individual(args)
      id = args.shift
      options = args.extract_options!
      Hashie::Mash.new(get("#{@@individual_collection_path}#{id}.xml", { :query => options }))
    end

  end
end
