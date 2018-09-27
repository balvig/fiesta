require "test_helper"

module Capistrano::Fiesta
  class GithubTest < Minitest::Test
    def test_client_being_configurable
      Github.config = { access_token: "ACCESS TOKEN" }

      assert_equal "ACCESS TOKEN", Github.client.access_token
    end
  end
end
