require 'faraday'

module AirbrakeAPI
  module Middleware
    class RaiseResponseError < Faraday::Response::Middleware

      def on_complete(env)
        if env[:body].errors && env[:body].errors.error
          raise AirbrakeError.new(env[:body].errors.error)
        end
      end

    end
  end
end