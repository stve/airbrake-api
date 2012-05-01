# placeholder since pre-refactor classes used AirbrakeAPI::Base
module AirbrakeAPI
  class Base
    class << self
      def setup
      end

      def fetch(path, options)
        Client.new.get(path, options)
      end

      def deprecate(msg)
        Kernel.warn("[Deprecation] - #{msg}")
      end
    end
  end
end