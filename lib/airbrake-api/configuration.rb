require 'airbrake-api/version'
require 'faraday_middleware'
require 'airbrake-api/middleware/scrub_response'
require 'airbrake-api/middleware/raise_server_error'
require 'airbrake-api/middleware/raise_response_error'

module AirbrakeAPI
  module Configuration
    VALID_OPTIONS_KEYS = [
      :account,
      :auth_token,
      :secure,
      :connection_options,
      :adapter,
      :user_agent,
      :middleware]

    attr_accessor *VALID_OPTIONS_KEYS

    DEFAULT_ADAPTER     = :net_http
    DEFAULT_USER_AGENT  = "AirbrakeAPI Ruby Gem #{AirbrakeAPI::VERSION}"
    DEFAULT_CONNECTION_OPTIONS = {}
    DEFAULT_MIDDLEWARE  = [
      Faraday::Request::UrlEncoded,
      AirbrakeAPI::Middleware::RaiseResponseError,
      FaradayMiddleware::Mashify,
      FaradayMiddleware::ParseXml,
      AirbrakeAPI::Middleware::ScrubResponse,
      AirbrakeAPI::Middleware::RaiseServerError]

    def self.extended(base)
      base.reset
    end

    def configure(options={})
      @account    = options[:account] if options.has_key?(:account)
      @auth_token = options[:auth_token] if options.has_key?(:auth_token)
      @secure     = options[:secure] if options.has_key?(:secure)
      @middleware = options[:middleware] if options.has_key?(:middleware)
      yield self if block_given?
      self
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    def account_path
      "#{protocol}://#{@account}.airbrake.io"
    end

    def protocol
      @secure ? "https" : "http"
    end

    def reset
      @account    = nil
      @auth_token = nil
      @secure     = false
      @adapter    = DEFAULT_ADAPTER
      @user_agent = DEFAULT_USER_AGENT
      @connection_options = DEFAULT_CONNECTION_OPTIONS
      @middleware = DEFAULT_MIDDLEWARE
    end

  end
end
