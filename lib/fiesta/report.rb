Encoding.default_internal = Encoding.default_external = "utf-8"

require "attr_extras/explicit"
require "fiesta/announcement"
require "fiesta/github"
require "fiesta/template"
require "fiesta/editor"
require "fiesta/logger"
require "fiesta/story"
require "fiesta/auto_composed_story"
require "fiesta/release"
require "fiesta/timestamp_normalizer"

module Fiesta
  class Report
    extend AttrExtras.mixin
    pattr_initialize :repo, [:current_revision, :previous_revision, :comment, :auto_compose]
    attr_query :auto_compose?

    def announce(config = {})
      return Logger.warn("Announcement blank, nothing posted to Slack") if nothing_to_announce?
      Announcement.new(text, config).post
    end

    def create_release(name = nil)
      return Logger.warn "No new stories, skipping GitHub release" if stories.none?
      Release.new(repo: repo, name: name, stories: stories).post
    end

    def stories
      @_stories ||= fetch_stories
    end

    private

      def fetch_stories
        if auto_compose?
          merged_pull_requests.map { |pr| AutoComposedStory.new(pr) }
        else
          merged_pull_requests.map { |pr| Story.new(pr) }
        end
      end

      def nothing_to_announce?
        stories.none? || text.nil? || text.empty?
      end

      def text
        @_text ||= render_text
      end

      def render_text
        if auto_compose?
          template
        else
          editor.compose
        end
      end

      def editor
        Editor.new(template, comment: comment)
      end

      def template
        Template.new(stories_with_release_notes).render
      end

      def stories_with_release_notes
        stories.find_all(&:release_note)
      end

      def merged_pull_requests
        github.search_issues("base:master repo:#{repo} #{merged_qualifier}").items
      rescue Octokit::UnprocessableEntity => e
        Logger.warn "Unable to access GitHub. Message given was: #{e.message}"
        []
      end

      def merged_qualifier
        if merged_before || merged_after
          "merged:#{merged_after&.iso8601 || '*'}..#{merged_before&.iso8601 || '*'}"
        else
          "is:merged"
        end
      end

      def merged_before
        return unless current_revision
        @_merged_before ||= github.commit(repo, current_revision).commit.committer.date + merge_leeway_seconds
      rescue Octokit::UnprocessableEntity => e
        Logger.warn "Unable to find a commit for #{current_revision}: #{e.message}"
      end

      def merged_after
        return unless previous_revision
        @_merged_after ||= github.commit(repo, previous_revision).commit.committer.date + merge_leeway_seconds
      rescue Octokit::UnprocessableEntity => e
        Logger.warn "Unable to find a commit for #{previous_revision}: #{e.message}"
      end

      def merge_leeway_seconds
        # Merging a pull request can happen a few seconds after the change is committed
        5
      end

      def github
        @_github ||= Github.client
      end
  end
end
