Encoding.default_internal = Encoding.default_external = 'utf-8'

require "capistrano/fiesta/github"
require "capistrano/fiesta/draft"
require "capistrano/fiesta/editor"
require "capistrano/fiesta/logger"
require "capistrano/fiesta/slack_dummy"
require "capistrano/fiesta/story"

module Capistrano
  module Fiesta
    class Report
      attr_reader :stories

      def initialize(github_url, last_release: nil, comment: nil)
        @github_url, @last_release, @comment = github_url, last_release, comment
        @stories = merged_pull_requests.map { |pr| Story.new(pr) }
      end

      def announce(options = {})
        text = editor.compose if stories.any?
        return Logger.warn('Announcement blank, nothing posted to Slack') if text.nil? || text.empty?
        options[:payload] = options.fetch(:payload, {}).merge(text: text)
        chat.post(options)
        text
      end

      def create_release(name = nil)
        return Logger.warn 'No new stories, skipping GitHub release' if stories.none?
        name ||= Time.now.to_i.to_s
        github.create_release(repo, "release-#{name}", name: name, body: stories.map(&:to_markdown).join("\n"))
      end

      private

        def editor
          Editor.new(draft.render)
        end

        def draft
          Draft.new(comment: @comment, stories: stories)
        end

        def merged_pull_requests
          github.search_issues("base:master repo:#{repo} merged:>#{last_released_at}").items
        rescue Octokit::UnprocessableEntity => e
          Logger.warn "Unable to access GitHub. Message given was: #{e.message}"
          []
        end

        def repo
          @github_url.match(/github.com[:\/](\S+\/\S+)\.git/)[1]
        end

        def last_released_at
          Time.parse(@last_release + 'Z00:00').iso8601 if @last_release
        end

        def github
          @github ||= Github.new.client
        end

        def chat
          Slackistrano
        rescue NameError
          SlackDummy.new
        end
    end
  end
end
