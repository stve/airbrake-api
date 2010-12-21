module Hoptoad
  class Error < Hoptoad::Base

    def self.find(*args)
      setup

      results = case args.first
        when Fixnum
          find_individual(args)
        when :all
          find_all(args)
        else
          raise HoptoadError.new('Invalid argument')
      end

      raise HoptoadError.new('No results found.') if results.nil?
      raise HoptoadError.new(results.errors.error) if results.errors

      results.group || results.groups
    end

    def self.update(error, options)
      setup

      self.class.put(collection_path, options)
    end

    private

    def self.find_all(args)
      options = args.extract_options!

      fetch(collection_path, options)
    end

    def self.find_individual(args)
      id = args.shift
      options = args.extract_options!

      fetch(error_path(id), options)
    end

    def self.collection_path
      '/errors.xml'
    end

    def self.error_path(error_id)
      "/errors/#{error_id}.xml"
    end

  end
end