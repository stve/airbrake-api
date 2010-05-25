require 'hashie'
require 'httparty'

module Hoptoad
  extend self
  attr_accessor :secure

  class HoptoadError < StandardError; end

  def account=(account)
    @account = account
  end

  def account
    "#{protocol}://#{@account}.hoptoadapp.com"
  end

  def auth_token=(token)
    @auth_token = token
  end

  def auth_token
    @auth_token
  end

  def protocol
    secure ? "https" : "http"
  end

end

require 'hoptoad-api/version'
require 'hoptoad-api/core_extensions'
require 'hoptoad-api/client'