require "capistrano/fiesta/story"
require "erb"
require "tempfile"
require "octokit"
require "yaml"

module Capistrano
  module Fiesta
    class Report
      def initialize(github_url, last_release: Time.now)
        @github_url, @last_release = github_url, last_release
      end

      def run
        file = Tempfile.new(['fiesta', '.md'])
        file << output
        file.close
        system(ENV["EDITOR"] || "vi", file.path)
      end

      def stories
        @stories ||= merged_pull_requests.map { |pr| Story.new(pr) }
      end

      def output
        ERB.new(File.read(template), nil, '-').result(binding)
      end

      private

        def template
          File.join(File.expand_path('../../templates', __FILE__), 'fiesta.erb')
        end

        def merged_pull_requests
          github.search_issues("base:master repo:#{repo} merged:>#{last_released_at}").items
        end

        def repo
          @github_url.match(/github.com[:\/](\S+\/\S+)\.git/)[1]
        end

        def last_released_at
          Time.parse(@last_release + 'Z00:00').iso8601
        end

        def github
          @github ||= Octokit::Client.new(config)
        end

        def config
          { access_token: hub_config["oauth_token"] }
        end

        def hub_config_path
          Dir.home + "/.config/hub"
        end

        def hub_config
          YAML.load_file(hub_config_path)["github.com"].first
        rescue Errno::ENOENT
          puts "No github config found at #{hub_config_path}, using ENV defaults (https://github.com/octokit/octokit.rb/blob/master/lib/octokit/default.rb)"
          {}
        end
    end
  end
end
