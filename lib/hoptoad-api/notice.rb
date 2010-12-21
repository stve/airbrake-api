module Hoptoad
  class Notice < Hoptoad::Base

    def self.find(id, error_id, options={})
      setup

      hash = fetch(find_path(id, error_id), options)

      if hash.errors
        raise HoptoadError.new(results.errors.error)
      end

      hash.notice
    end

    def self.find_all_by_error_id(error_id)
      setup

      options = {}
      notices = []
      page = 1
      while true
        options[:page] = page
        hash = fetch(all_path(error_id), options)
        if hash.errors
          raise HoptoadError.new(results.errors.error)
        end
        notice_stubs = hash.notices

        notice_stubs.map do |notice|
          notices << find(notice.id, error_id)
        end
        break if notice_stubs.size < 30
        page += 1
      end
      notices
    end

    def self.find_by_error_id(error_id, options={ 'page' => 1})
      setup

      hash = fetch(all_path(error_id), options)
      if hash.errors
        raise HoptoadError.new(results.errors.error)
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