require "test_helper"

module Fiesta
  class SlackTest < Minitest::Test
    def test_post
      webhook = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
      payload = { text: "• New login\n" }
      stub = stub_request(:post, webhook).with(body: payload)
      Slack.new(webhook: webhook, payload: payload).post
      assert_requested stub
    end
  end
end
