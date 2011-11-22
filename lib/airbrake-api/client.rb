module AirbrakeAPI
  class Client
    include HTTParty
    format :xml

    PER_PAGE = 30
    PARALLEL_WORKERS = 10

    def self.setup
      base_uri AirbrakeAPI.account_path
      default_params :auth_token => AirbrakeAPI.auth_token

      check_configuration
    end

    def self.check_configuration
      raise AirbrakeError.new('API Token cannot be nil') if default_options.nil? || default_options[:default_params].nil? || !default_options[:default_params].has_key?(:auth_token)
      raise AirbrakeError.new('Account cannot be nil') unless default_options.has_key?(:base_uri)
    end

    def self.fetch(path, options)
      setup

      response = get(path, { :query => options })
      if response.code == 403
        raise AirbrakeError.new('SSL should be enabled - use AirbrakeAPI.secure = true in configuration')
      end

      Hashie::Mash.new(response)
    end

    # deploys

    def deploys(project_id, options = {})
      results = self.class.fetch("/projects/#{project_id}/deploys.xml", options)
      raise AirbrakeError.new(results.errors.error) if results.errors
      results.projects.deploy
    end

    # projects
    def projects_path
      '/data_api/v1/projects.xml'
    end

    def projects(options = {})
      results = self.class.fetch(projects_path, options)

      raise AirbrakeError.new(results.errors.error) if results.errors
      results.projects.project
    end

    # errors

    def error_path(error_id)
      "/errors/#{error_id}.xml"
    end

    def errors_path
      '/errors.xml'
    end

    def update(error, options = {})
      response = self.class.put(error_path(error), :body => options)
      if response.code == 403
        raise AirbrakeError.new('SSL should be enabled - use Airbrake.secure = true in configuration')
      end
      results = Hashie::Mash.new(response)

      raise AirbrakeError.new(results.errors.error) if results.errors
      results.group
    end

    def error(error_id, options = {})
      results = self.class.fetch(error_path(error_id), options)

      raise AirbrakeError.new('No results found.') if results.nil?
      raise AirbrakeError.new(results.errors.error) if results.errors

      results.group || results.groups
    end

    def errors(options = {})
      results = self.class.fetch(errors_path, options)

      raise AirbrakeError.new('No results found.') if results.nil?
      raise AirbrakeError.new(results.errors.error) if results.errors

      results.group || results.groups
    end

    # notices

    def notice_path(notice_id, error_id)
      "/errors/#{error_id}/notices/#{notice_id}.xml"
    end

    def notices_path(error_id)
      "/errors/#{error_id}/notices.xml"
    end

    def notice(notice_id, error_id, options = {})
      hash = self.class.fetch(notice_path(notice_id, error_id), options)

      raise AirbrakeError.new(results.errors.error) if hash.errors

      hash.notice
    end

    def notices(error_id, options = {})
      options['page'] ||= 1
      hash = self.class.fetch(notices_path(error_id), options)

      raise AirbrakeError.new(results.errors.error) if hash.errors

      hash.notices
    end

    def all_notices(error_id, notice_options = {}, &block)
      options = {}
      notices = []
      page = 1
      while !notice_options[:pages] || page <= notice_options[:pages]
        options[:page] = page
        hash = self.class.fetch(notices_path(error_id), options)
        if hash.errors
          raise AirbrakeError.new(results.errors.error)
        end

        batch = Parallel.map(hash.notices, :in_threads => PARALLEL_WORKERS) do |notice_stub|
          notice(notice_stub.id, error_id)
        end
        yield batch if block_given?
        batch.each{|n| notices << n }

        break if batch.size < PER_PAGE
        page += 1
      end
      notices
    end

  end
end

# airbrake sometimes returns broken xml with invalid xml tag names
# so we remove them
require 'httparty/parser'
class HTTParty::Parser
  def xml
    body.gsub!(/<__utmz>.*?<\/__utmz>/m,'')
    body.gsub!(/<[0-9]+.*?>.*?<\/[0-9]+.*?>/m,'')
    MultiXml.parse(body)
  end
end
