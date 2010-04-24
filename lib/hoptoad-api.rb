require 'hashie'
require 'httparty'

module Hoptoad
  extend self
  
  class HoptoadError < StandardError; end
  
  def account=(account)
    @account = account
  end
  
  def account
    "http://#{@account}.hoptoadapp.com"
  end
  
  def auth_token=(token)
    @auth_token = token
  end
  
  def auth_token
    @auth_token
  end
end

require 'hoptoad-api/version'
require 'hoptoad-api/core_extensions'
require 'hoptoad-api/client'