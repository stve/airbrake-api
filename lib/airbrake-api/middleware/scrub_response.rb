require 'faraday'

module AirbrakeAPI
  module Middleware
    class ScrubResponse < Faraday::Response::Middleware

      def parse(body)
        body.gsub!(/<__utmz>.*?<\/__utmz>/m,'')
        body.gsub!(/<[0-9]+.*?>.*?<\/[0-9]+.*?>/m,'')
        body
      end

    end
  end
end