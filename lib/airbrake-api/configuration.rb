module AirbrakeAPI
  module Configuration
    VALID_OPTIONS_KEYS = [
      :account,
      :auth_token,
      :secure,
      :connection_options]

    attr_accessor *VALID_OPTIONS_KEYS

    def configure(options={})
      @account    = options[:account] if options.has_key?(:account)
      @auth_token = options[:auth_token] if options.has_key?(:auth_token)
      @secure     = options[:secure] if options.has_key?(:secure)
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
    end

  end
end
