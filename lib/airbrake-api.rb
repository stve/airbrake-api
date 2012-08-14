require 'airbrake-api/configuration'

module AirbrakeAPI
  extend Configuration

  class AirbrakeError < StandardError; end

  # Alias for Instapaper::Client.new
  #
  # @return [Instapaper::Client]
  def self.client(options={})
    AirbrakeAPI::Client.new(options)
  end

   # Delegate to Instapaper::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  def self.respond_to?(method, include_private = false)
    client.respond_to?(method, include_private) || super(method, include_private)
  end
end

require 'airbrake-api/client'
require 'airbrake-api/error'
require 'airbrake-api/notice'
require 'airbrake-api/project'
