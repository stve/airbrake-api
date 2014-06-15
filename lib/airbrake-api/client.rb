require 'parallel'
require 'airbrake-api/core_ext/hash'

module AirbrakeAPI
  class Client

    PER_PAGE = 20
    PARALLEL_WORKERS = 10

    attr_accessor *AirbrakeAPI::Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      attrs = AirbrakeAPI.options.merge(options)
      AirbrakeAPI::Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", attrs[key])
      end
    end

    def url_for(endpoint, *args)
      path = case endpoint.to_s
      when 'deploys' then deploys_path(*args)
      when 'projects' then '/projects'
      when 'errors' then errors_path(*args)
      when 'error' then error_path(*args)
      when 'notices' then notices_path(*args)
      when 'notice' then notice_path(*args)
      else raise ArgumentError.new("Unrecognized path: #{path}")
      end

      [account_path, path.split('.').first].join('')
    end

    # deploys

    def deploys(project_id, options = {})
      results = request(:get, deploys_path(project_id), options)
      results.deploys.respond_to?(:deploy) ? results.deploys.deploy : []
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

    def unformatted_error_path(error_id)
      "/errors/#{error_id}"
    end

    def error_path(error_id)
      "#{unformatted_error_path(error_id)}.xml"
    end

    def errors_path(options={})
      "#{options[:project_id] ? "/projects/#{options[:project_id]}" : nil}/groups.xml"
    end

    def update(error, options = {})
      results = request(:put, unformatted_error_path(error), options)
      results.group
    end

    def error(error_id, options = {})
      results = request(:get, error_path(error_id), options)
      results.group || results.groups
    end

    def errors(options = {})
      options = options.dup
      project_id = options.delete(:project_id)
      results = request(:get, errors_path(:project_id => project_id), options)
      results.group || results.groups
    end

    # notices

    def notice_path(notice_id, error_id)
      "/groups/#{error_id}/notices/#{notice_id}.xml"
    end

    def notices_path(error_id)
      "/groups/#{error_id}/notices.xml"
    end

    def notice(notice_id, error_id, options = {})
      hash = request(:get, notice_path(notice_id, error_id), options)
      hash.notice
    end

    def notices(error_id, options = {}, &block)
      # a specific page is requested, only return that page
      # if no page is specified, start on page 1
      if options[:page]
        page = options[:page]
        options[:pages] = 1
      else
        page = 1
      end

      notices = []
      page_count = 0
      while !options[:pages] || (page_count + 1) <= options[:pages]
        data = request(:get, notices_path(error_id), :page => page + page_count)

        batch = if options[:raw]
          data.notices
        else
          # get info like backtraces by doing another api call to notice
          Parallel.map(data.notices, :in_threads => PARALLEL_WORKERS) do |notice_stub|
            notice(notice_stub.id, error_id)
          end
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

      response = connection(options).run_request(method, nil, nil, nil) do |request|
        case method
        when :delete, :get
          request.url(path, params.merge(:auth_token => @auth_token))
        when :post, :put
          request.url(path, :auth_token => @auth_token)
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
        middleware.each { |mw| builder.use *mw }

        builder.adapter adapter
      end
    end

  end
end
