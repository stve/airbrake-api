module AirbrakeAPI
  class Project

    # @deprecated Please use {AirbrakeAPI::Client.projects} instead
    def self.find(*args)
      deprecate('Project.find has been deprecated; use AibrakeAPI::Client.projects instead')
      options = args.extract_options!
      AirbrakeAPI::Client.new.projects(options)
    end

    # @deprecated Please use {AirbrakeAPI::Client.projects_path} instead
    def self.collection_path
      deprecate('Project.collection_path has been deprecated; use AibrakeAPI::Client.projects_path instead')
      AirbrakeAPI::Client.new.projects_path
    end

    def self.deprecate(msg)
      Kernel.warn("[Deprecation] - #{msg}")
    end
  end
end