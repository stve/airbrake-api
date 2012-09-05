require 'parallel'
require 'airbrake-api/base'

module AirbrakeAPI
  class Notice < Base

    # @deprecated Please use {AirbrakeAPI::Client::notice} instead
    def self.find(id, error_id, options = {})
      deprecate('Notice.find has been deprecated; use AibrakeAPI::Client#notice instead')
      AirbrakeAPI::Client.new.notice(id, error_id, options)
    end

    # @deprecated Please use {AirbrakeAPI::Client::all_notices} instead
    def self.find_all_by_error_id(error_id, notice_options = {}, &block)
      deprecate('Notice.find_all_by_error_id has been deprecated; use AibrakeAPI::Client#notices instead')
      AirbrakeAPI::Client.new.notices(error_id, notice_options, &block)
    end

    # @deprecated Please use {AirbrakeAPI::Client::notices} instead
    def self.find_by_error_id(error_id, options = {})
      deprecate('Notice.find_by_error_id has been deprecated; use AibrakeAPI::Client#notices instead')
      AirbrakeAPI::Client.new.notices(error_id, options)
    end

    # @deprecated Please use {AirbrakeAPI::Client::notice_path} instead
    def self.find_path(id, error_id)
      deprecate('Notice.find_path has been deprecated; use AibrakeAPI::Client#notice_path instead')
      AirbrakeAPI::Client.new.notice_path(id, error_id)
    end

    # @deprecated Please use {AirbrakeAPI::Client::notices_path} instead
    def self.all_path(error_id)
      deprecate('Notice.all_path has been deprecated; use AibrakeAPI::Client#notices_path instead')
      AirbrakeAPI::Client.new.notices_path(error_id)
    end

  end
end
