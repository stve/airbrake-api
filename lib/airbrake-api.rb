require 'hashie'
require 'httparty'

module AirbrakeAPI
  extend self
  attr_accessor :account, :auth_token, :secure

  class AirbrakeError < StandardError; end

  def configure(options={})
    @account = options[:account] if options.has_key?(:account)
    @auth_token = options[:auth_token] if options.has_key?(:auth_token)
    @secure = options[:secure] if options.has_key?(:secure)
  end

  def account_path
    "#{protocol}://#{@account}.airbrakeapp.com"
  end

  def protocol
    secure ? "https" : "http"
  end

  def reset
    @account = nil
    @auth_token = nil
    @secure = false
  end

end

require 'airbrake-api/core_extensions'
require 'airbrake-api/client'
require 'airbrake-api/error'
require 'airbrake-api/notice'
require 'airbrake-api/project'