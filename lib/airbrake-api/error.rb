module Airbrake
  class Error < Airbrake::Base

    def self.find(*args)
      setup

      results = case args.first
        when Fixnum
          find_individual(args)
        when :all
          find_all(args)
        else
          raise AirbrakeError.new('Invalid argument')
      end

      raise AirbrakeError.new('No results found.') if results.nil?
      raise AirbrakeError.new(results.errors.error) if results.errors

      results.group || results.groups
    end

    def self.update(error, options)
      setup

      response = put(error_path(error), :body => options)
      if response.code == 403
        raise AirbrakeError.new('SSL should be enabled - use Airbrake.secure = true in configuration')
      end
      results = Hashie::Mash.new(response)

      raise AirbrakeError.new(results.errors.error) if results.errors
      results.group
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