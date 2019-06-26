require "test_helper"

module Capistrano::Fiesta
  class Editor
    def system(*args)
      true
    end
  end

  class ReportTest < Minitest::Test
    def setup
      stub_request(:get, /github.com\/search/).to_return_json(items: [{ title: "New login", body: "", html_url: "www.github.com" }])
      stub_request(:post, webhook)
    end

    def test_announce
      query = "base:master repo:balvig/capistrano-fiesta merged:>2015-10-09T14:50:23Z"
      response = { items: [{ title: "New login [Delivers #123]", body: "" }] }
      github = stub_request(:get, "https://api.github.com:443/search/issues").with(query: { q: query }).to_return_json(response)

      expected = <<-ANNOUNCEMENT
• New login
      ANNOUNCEMENT
      announcement = Report.new(repo, last_released_at: "20151009145023").announce(webhook: webhook)
      assert_equal expected, announcement
      assert_requested github
    end

    def test_announce_with_comment
      expected = <<-ANNOUNCEMENT
• New login
      ANNOUNCEMENT

      report = Report.new(repo, comment: "Only include new features") # Not sure how to test the contents of the editor
      announcement = report.announce(webhook: webhook)
      assert_equal expected, announcement
    end

    def test_creating_release_on_github
      release_endpoint = stub_request(:post, "https://api.github.com/repos/balvig/capistrano-fiesta/releases").with(body: { name: "20151009145023", body: "- [New login](www.github.com)", tag_name: "release-20151009145023" })
      Report.new(repo).create_release('20151009145023')
      assert_requested release_endpoint
    end

    def test_creating_release_with_no_stories
      stub_request(:get, /github.com/).to_return_json(items: [])
      release_endpoint = stub_request(:post, "https://api.github.com/repos/balvig/capistrano-fiesta/releases")
      Report.new(repo).create_release('20151009145023')
      assert_not_requested release_endpoint
      assert_equal "[FIESTA] No new stories, skipping GitHub release", Logger.logs.last
    end

    def test_announce_with_options
      stub = stub_request(:post, webhook).with(body: { text: "• New login\n" })
      Report.new(repo).announce(webhook: webhook)
      assert_requested stub
    end

    def test_announce_with_no_stories
      stub_request(:get, /github.com/).to_return_json(items: [])
      Report.new(repo).announce(webhook: webhook)
      assert_equal "[FIESTA] Announcement blank, nothing posted to Slack", Logger.logs.last
    end

    def test_announce_with_auto_compose_mode
      response = {
        items: [
          { title: "No release note in body", body: "No notes" },
          { title: "Release note in body", body: "_Release note: New feature_" }
        ]
      }

      stub_request(:get, /search/).to_return_json(response)

      expected = <<-ANNOUNCEMENT
• New feature
      ANNOUNCEMENT
      announcement = Report.new(repo, last_released_at: "20151009145023", auto_compose: true).announce(webhook: webhook)
      assert_equal expected, announcement
    end

    private

      def repo
        "balvig/capistrano-fiesta"
      end

      def webhook
        "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
      end
  end
end
