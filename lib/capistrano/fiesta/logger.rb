module Capistrano
  module Fiesta
    class Logger
      @logs = []

      def self.warn(message)
        @logs << "[FIESTA] #{message}"
      end

      def self.logs
        @logs
      end
    end
  end
end
