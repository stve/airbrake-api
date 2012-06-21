require 'faraday_middleware'
require 'airbrake-api/middleware/scrub_response'
require 'airbrake-api/middleware/raise_server_error'
require 'airbrake-api/middleware/raise_response_error'

module AirbrakeAPI
  class Client

    PER_PAGE = 30
    PARALLEL_WORKERS = 10

    attr_accessor *AirbrakeAPI::Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      attrs = AirbrakeAPI.options.merge(options)
      AirbrakeAPI::Configuration::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
    end

    # deploys

    def deploys(project_id, options = {})
      results = request(:get, deploys_path(project_id), options)
      results.projects.deploy
    end

    def deploys_path(project_id)
      "/projects/#{project_id}/deploys.xml"
    end

    # projects
    def projects_path
      '/data_api/v1/projects.xml'
    end

    def projects(options = {})
      results = request(:get, projects_path, options)
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
      results = request(:put, error_path(error), :body => options)
      results.group
    end

    def error(error_id, options = {})
      results = request(:get, error_path(error_id), options)
      results.group || results.groups
    end

    def errors(options = {})
      results = request(:get, errors_path, options)
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
      hash = request(:get, notice_path(notice_id, error_id), options)
      hash.notice
    end

    def notices(error_id, notice_options = {}, &block)
      options     = {}
      notices     = []
      page        = notice_options[:page]
      page_count  = 0

      # a specific page is requested, only return that page
      # if no page is specified, start on page 1
      if page
        notice_options[:pages] = 1
      else
        page = 1
      end

      while !notice_options[:pages] || (page_count + 1) <= notice_options[:pages]
        options[:page] = page + page_count
        hash = request(:get, notices_path(error_id), options)

        batch = Parallel.map(hash.notices, :in_threads => PARALLEL_WORKERS) do |notice_stub|
          notice(notice_stub.id, error_id)
        end
        yield batch if block_given?
        batch.each{|n| notices << n }

        break if batch.size < PER_PAGE
        page_count += 1
      end
      notices
    end

    private

    def account_path
      "#{protocol}://#{@account}.airbrake.io"
    end

    def protocol
      @secure ? "https" : "http"
    end

    # Perform an HTTP request
    def request(method, path, params = {}, options = {})

      raise AirbrakeError.new('API Token cannot be nil') if @auth_token.nil?
      raise AirbrakeError.new('Account cannot be nil') if @account.nil?

      params.merge!(:auth_token => @auth_token)

      response = connection(options).run_request(method, nil, nil, nil) do |request|
        case method.to_sym
        when :delete, :get
          request.url(path, params)
        when :post, :put
          request.path = path
          request.body = params unless params.empty?
        end
      end
      response.body
    end

    def connection(options={})
      default_options = {
        :headers => {
          :accept => 'application/xml',
          :user_agent => user_agent,
        },
        :ssl => {:verify => false},
        :url => account_path,
      }
      @connection ||= Faraday.new(default_options.deep_merge(connection_options)) do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use AirbrakeAPI::Middleware::RaiseResponseError
        builder.use FaradayMiddleware::Mashify
        builder.use FaradayMiddleware::ParseXml
        builder.use AirbrakeAPI::Middleware::ScrubResponse
        builder.use AirbrakeAPI::Middleware::RaiseServerError

        builder.adapter adapter
      end
    end

  end
end
