require 'parallel'

module AirbrakeAPI
  class Notice < AirbrakeAPI::Base
    PER_PAGE = 30
    PARALLEL_WORKERS = 10

    def self.find(id, error_id, options={})
      setup

      hash = fetch(find_path(id, error_id), options)

      if hash.errors
        raise AirbrakeError.new(results.errors.error)
      end

      hash.notice
    end

    def self.find_all_by_error_id(error_id, notice_options = {})
      setup

      options = {}
      notices = []
      page = 1
      while !notice_options[:pages] || page <= notice_options[:pages]
        options[:page] = page
        hash = fetch(all_path(error_id), options)
        if hash.errors
          raise AirbrakeError.new(hash.errors.error)
        end

        batch = Parallel.map(hash.notices, :in_threads => PARALLEL_WORKERS) do |notice_stub|
          find(notice_stub.id, error_id)
        end
        yield batch if block_given?
        batch.each{|n| notices << n }

        break if batch.size < PER_PAGE
        page += 1
      end
      notices
    end

    def self.find_by_error_id(error_id, options={ 'page' => 1})
      setup

      hash = fetch(all_path(error_id), options)
      if hash.errors
        raise AirbrakeError.new(results.errors.error)
      end

      hash.notices
    end

    private

    def self.find_path(id, error_id)
      "/errors/#{error_id}/notices/#{id}.xml"
    end

    def self.all_path(error_id)
      "/errors/#{error_id}/notices.xml"
    end
  end
end
