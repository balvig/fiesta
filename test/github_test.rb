require "test_helper"

module Capistrano::Fiesta
  class GithubTest < Minitest::Test
    def test_client_being_configurable
      Github.config = { access_token: "ACCESS TOKEN" }

      assert_equal "ACCESS TOKEN", Github.client.access_token
    end

    def test_access_token_defaulting_to_env_value
      refute Github.client.access_token.nil?, "Expected `access_token` to get set from OCTOKIT_ACCESS_TOKEN"
    end
  end
end
