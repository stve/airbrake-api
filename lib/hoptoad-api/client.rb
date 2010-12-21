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