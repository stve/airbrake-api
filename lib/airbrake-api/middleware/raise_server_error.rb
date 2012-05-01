require 'faraday'

module AirbrakeAPI
  module Middleware
    class RaiseServerError < Faraday::Response::Middleware

      def on_complete(env)
        case env[:status].to_i
        when 403
          raise AirbrakeError.new('SSL should be enabled - use AirbrakeAPI.secure = true in configuration')
        end
      end

    end
  end
end