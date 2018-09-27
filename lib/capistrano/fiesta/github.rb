require "octokit"
require "yaml"

module Capistrano
  module Fiesta
    class Github
      class << self
        attr_accessor :config
      end

      def self.client
        new.client
      end

      def client
        Octokit::Client.new(config)
      end

      private

        def config
          self.class.config || default_config
        end

        def default_config
          { access_token: hub_config["oauth_token"] }
        end

        def hub_config_path
          Dir.home + "/.config/hub"
        end

        def hub_config
          YAML.load_file(hub_config_path)["github.com"].first
        rescue Errno::ENOENT
          Logger.warn "No github config found at #{hub_config_path}, using ENV defaults (https://github.com/octokit/octokit.rb/blob/master/lib/octokit/default.rb)"
          {}
        end
    end
  end
end
