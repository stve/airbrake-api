require 'airbrake-api/base'

module AirbrakeAPI
  class Error < Base

    # @deprecated Please use {AirbrakeAPI::Client::error} and {AirbrakeAPI::Client::errors} instead
    def self.find(*args)
      deprecate('Error.find has been deprecated; use AibrakeAPI::Client#error and AibrakeAPI::Client#errors instead')

      results = case args.first
        when Fixnum
          id = args.shift
          options = args.extract_options!
          AirbrakeAPI::Client.new.error(id, options)
        when :all
          options = args.extract_options!
          AirbrakeAPI::Client.new.errors(options)
        else
          raise AirbrakeError.new('Invalid argument')
      end

      results
    end

    # @deprecated Please use {AirbrakeAPI::Client::update} instead
    def self.update(error, options)
      deprecate('Error.update has been deprecated; use AibrakeAPI::Client#update instead')
      AirbrakeAPI::Client.new.update(error, options)
    end

    # @deprecated Please use {AirbrakeAPI::Client::errors_path} instead
    def self.collection_path
      deprecate('Error.collection_path has been deprecated; use AibrakeAPI::Client#errors_path instead')
      AirbrakeAPI::Client.new.errors_path
    end

    # @deprecated Please use {AirbrakeAPI::Client::error_path} instead
    def self.error_path(error_id)
      deprecate('Error.error_path has been deprecated; use AibrakeAPI::Client#error_path instead')
      AirbrakeAPI::Client.new.error_path(error_id)
    end

  end
end