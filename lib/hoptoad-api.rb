require 'hashie'
require 'httparty'

module Hoptoad
  extend self
  attr_accessor :account, :auth_token, :secure

  class HoptoadError < StandardError; end

  def configure(options={})
    @account = options[:account] if options.has_key?(:account)
    @auth_token = options[:auth_token] if options.has_key?(:auth_token)
    @secure = options[:secure] if options.has_key?(:secure)
  end

  def account_path
    "#{protocol}://#{@account}.hoptoadapp.com"
  end

  def protocol
    secure ? "https" : "http"
  end

end

require 'hoptoad-api/core_extensions'
require 'hoptoad-api/client'
require 'hoptoad-api/notice'
require 'hoptoad-api/error'