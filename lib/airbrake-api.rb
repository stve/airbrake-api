require 'airbrake-api/configuration'

module AirbrakeAPI
  extend Configuration

  class AirbrakeError < StandardError; end
end

require 'airbrake-api/client'
require 'airbrake-api/error'
require 'airbrake-api/notice'
require 'airbrake-api/project'
