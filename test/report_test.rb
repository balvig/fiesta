require "test_helper"

module Capistrano::Fiesta
  class Editor
    def system(*args)
      true
    end
  end

  class ReportTest < Minitest::Test
    def setup
      compare_response = { commits: [{ commit: { message: "Merge pull request #42 from new-login" }}]}
      stub_request(:get, "https://api.github.com:443/repos/balvig/capistrano-fiesta/compare/21b8426...b0de556").to_return_json(compare_response)
      pull_request_response = { title: "New login", html_url: "www.github.com" }
      stub_request(:get, "https://api.github.com:443/repos/balvig/capistrano-fiesta/pulls/42").to_return_json(pull_request_response)
    end

    def test_announce
      compare_response = { commits: [{ commit: { message: "Merge pull request #42 from new-login" }}]}
      compare_endpoint = stub_request(:get, "https://api.github.com:443/repos/balvig/capistrano-fiesta/compare/21b8426...b0de556").to_return_json(compare_response)
      pull_request_response = { title: "New login [Delivers #123]", body: "" }
      pull_request_endpoint = stub_request(:get, "https://api.github.com:443/repos/balvig/capistrano-fiesta/pulls/42").to_return_json(pull_request_response)

      expected = <<-ANNOUNCEMENT
• New login
      ANNOUNCEMENT
      announcement = Report.new(repo, current_revision: "b0de556", previous_revision: "21b8426").announce
      assert_equal expected, announcement
      assert_requested compare_endpoint
      assert_requested pull_request_endpoint
    end

    def test_announce_with_comment
      expected = <<-ANNOUNCEMENT
• New login
      ANNOUNCEMENT

      report = Report.new(repo, current_revision: "b0de556", previous_revision: "21b8426", comment: "Only include new features") # Not sure how to test the contents of the editor
      announcement = report.announce
      assert_equal expected, announcement
    end

    def test_creating_release_on_github
      release_endpoint = stub_request(:post, "https://api.github.com/repos/balvig/capistrano-fiesta/releases").with(body: { name: "20151009145023", body: "- [New login](www.github.com)", tag_name: "release-20151009145023" })
      Report.new(repo, current_revision: "b0de556", previous_revision: "21b8426").create_release('20151009145023')
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
      Report.new(repo, current_revision: "b0de556", previous_revision: "21b8426").announce(team: 'bobcats', token: '1234')

      post = {
        team: 'bobcats',
        token: '1234',
        payload: {
          text: "• New login\n"
        }
      }

      assert_equal post, SlackDummy.log
    end

    def test_announce_without_chat_client
      Report.new(repo, current_revision: "b0de556", previous_revision: "21b8426").announce
      assert Logger.logs.last.include?("[FIESTA] Install Slackistrano to announce releases on Slack")
    end

    def test_announce_with_no_stories
      stub_request(:get, /github.com/).to_return_json(items: [])
      Report.new(repo).announce
      assert_equal "[FIESTA] Announcement blank, nothing posted to Slack", Logger.logs.last
    end

    def test_announce_with_auto_compose_mode
      compare_response = {
        commits: [
          { commit: { message: "Merge pull request #43 from release-note-in-body" }},
          { commit: { message: "Merge pull request #42 from no-release-note-in-body" }}
        ]
      }
      compare_endpoint = stub_request(:get, "https://api.github.com:443/repos/balvig/capistrano-fiesta/compare/21b8426...b0de556").to_return_json(compare_response)
      pull_request_response = { title: "No release note in body", body: "No notes" }
      stub_request(:get, "https://api.github.com:443/repos/balvig/capistrano-fiesta/pulls/42").to_return_json(pull_request_response)
      pull_request_response = { title: "Release note in body", body: "_Release note: New feature_" }
      stub_request(:get, "https://api.github.com:443/repos/balvig/capistrano-fiesta/pulls/43").to_return_json(pull_request_response)

      expected = <<-ANNOUNCEMENT
• New feature
      ANNOUNCEMENT
      announcement = Report.new(repo, current_revision: "b0de556", previous_revision: "21b8426", auto_compose: true).announce
      assert_equal expected, announcement
    end

    private

      def repo
        "git@github.com:balvig/capistrano-fiesta.git"
      end
  end
end
