require 'rubygems'

begin
  require 'uri'
  require 'addressable/uri'

  module URI
    def decode(*args)
      Addressable::URI.decode(*args)
    end

    def escape(*args)
      Addressable::URI.escape(*args)
    end

    def parse(*args)
      Addressable::URI.parse(*args)
    end
  end
rescue LoadError
  puts "Install the Addressable gem to support accounts with subdomains."
  puts "# sudo gem install addressable"
  puts
end

require 'activesupport'
require 'activeresource'

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
module Hoptoad
  class HoptoadError < StandardError; end
  class << self
    attr_accessor :host_format, :domain_format, :protocol, :port
    attr_reader :account, :token

    # Sets the account name, and updates all the resources with the new domain.
    def account=(name)
      resources.each do |klass|
        klass.site = klass.site_format % (host_format % [protocol, domain_format % name, ":#{port}"])
      end
      @account = name
    end

    # Sets the API token for all the resources.
    def token=(value)
      @token = value
    end

    def resources
      @resources ||= []
    end
  end
  
  self.host_format   = '%s://%s%s'
  self.domain_format = '%s.hoptoadapp.com'
  self.protocol      = 'http'
  self.port          = ''

  class Base < ActiveResource::Base
    def self.inherited(base)
      Hoptoad.resources << base
      class << base
        attr_accessor :site_format
        
        def append_auth_token_to_params(*arguments)
          opts = arguments.last.is_a?(Hash) ? arguments.pop : {}
          opts = opts.has_key?(:params) ? opts : opts.merge(:params => {})
          opts[:params] = opts[:params].merge(:auth_token => Hoptoad.token)
          arguments << opts
          arguments
        end        
      end
      base.site_format = '%s'
      super
    end
  end
  
  # Find errors
  #
  #   Errors are paginated. You get 25 at a time.
  #   Hoptoad::Error.find(:all)
  #   Hoptoad::Error.find(:all, :params => { :page => 2 })
  #
  #   find individual error by ID
  #   Hoptoad::Error.find(44) 
  #
  class Error < Base
    
    # find using token
    def self.find(*arguments)
      raise HoptoadError.new('API Token cannot be nil') if Hoptoad.token.blank?
      raise HoptoadError.new('Account cannot be nil') if Hoptoad.account.blank?
      
      arguments = append_auth_token_to_params(*arguments)
      super(*arguments)
    end  
    
    # produces the url on hoptoad's site
    def url
      path = Error.site.to_s
      path << collection_path.gsub!(/^\//,'')
      path.gsub!('.xml','')
      path << '/'
      path << self.id.to_s
    end
    
  end

end
