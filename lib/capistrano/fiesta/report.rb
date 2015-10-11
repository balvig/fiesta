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

      private

        def output
          ERB.new(File.read(template), nil, '-').result(binding)
        end

        def strip_tags(title)
          title.sub(/\[Delivers #\d+\]\z/, '').strip
        end

        def template
          File.join(File.expand_path('../../templates', __FILE__), 'fiesta.erb')
        end

        def merged_pull_requests
          @merged_pull_requests ||= github.search_issues("base:master repo:#{repo} merged:>#{last_released_at}").items
        end

        def repo
          @github_url.match(/github.com[:\/](\S+\/\S+)\.git/)[1]
        end

        def last_released_at
          Time.parse(@last_release + 'Z00:00').iso8601
        end

        def github
          @github ||= Octokit::Client.new(login: config["user"], access_token: config["oauth_token"])
        end

        def config
          hub_config_path = Dir.home + "/.config/hub"
          hub_config = YAML.load_file hub_config_path
          hub_config["github.com"].first
        end
    end
  end
end
