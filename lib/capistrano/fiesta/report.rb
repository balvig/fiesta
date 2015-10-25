Encoding.default_internal = Encoding.default_external = 'utf-8'

require "capistrano/fiesta/story"
require "capistrano/fiesta/editor"
require "erb"
require "octokit"
require "yaml"

module Capistrano
  module Fiesta
    class Report
      attr_accessor :logs, :comment

      def initialize(github_url, last_release: nil, comment: nil)
        @github_url, @last_release, @comment = github_url, last_release, comment
        @logs = []
      end

      def write
        editor.open if stories.any?
      end

      def stories
        @stories ||= merged_pull_requests.map { |pr| Story.new(pr) }
      end

      private

        def editor
          Editor.new(draft)
        end

        def draft
          ERB.new(File.read(template), nil, '-').result(binding)
        end

        def template
          File.join(File.expand_path('../../templates', __FILE__), 'fiesta.erb')
        end

        def merged_pull_requests
          github.search_issues("base:master repo:#{repo} merged:>#{last_released_at}").items
        rescue Octokit::UnprocessableEntity => e
          log "Unable to access GitHub. Message given was: #{e.message}"
          []
        end

        def repo
          @github_url.match(/github.com[:\/](\S+\/\S+)\.git/)[1]
        end

        def last_released_at
          Time.parse(@last_release + 'Z00:00').iso8601 if @last_release
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
          log "No github config found at #{hub_config_path}, using ENV defaults (https://github.com/octokit/octokit.rb/blob/master/lib/octokit/default.rb)"
          {}
        end

        def log(message)
          @logs << "[FIESTA] #{message}"
        end
    end
  end
end
