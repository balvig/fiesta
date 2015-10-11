require "erb"
require "tempfile"
require "octokit"
require "yaml"

module Capistrano
  module Fiesta
    class Report
      def initialize(last_release)
        @last_release = last_release
        @repo = "cookpad/global-web"
      end

      def run
        file = Tempfile.new(['fiesta', '.md'])
        file << output
        file.close
        `open #{file.path}`
      end

      private

        def output
          ERB.new(File.read(template), nil, '-').result(instance_eval { binding })
        end

        def template
          File.join(File.expand_path('../../templates', __FILE__), 'fiesta.erb')
        end

        def merged_pull_requests
          github.search_issues("base:master repo:#{@repo} merged:>=#{last_released_at}").items.map do |pr|
            pr.title.sub(/\[.+\]/, '')
          end
        end

        def github
          @github ||= Octokit::Client.new(login: config["user"], access_token: config["oauth_token"])
        end

        def last_released_at
          Time.parse(@last_release).iso8601
        end

        def config
          hub_config_path = Dir.home + "/.config/hub"
          hub_config = YAML.load_file hub_config_path
          hub_config["github.com"].first
        end
    end
  end
end
