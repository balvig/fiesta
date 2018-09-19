require "test_helper"

module Fiesta
  class RepoUrlParserTest < Minitest::Test
    def test_ssh_url
      parser = RepoUrlParser.new("git@github.com:balvig/capistrano-fiesta.git")
      assert_equal "balvig/capistrano-fiesta", parser.repo
    end

    def test_clone_url
      parser = RepoUrlParser.new("https://github.com/balvig/capistrano-fiesta.git")
      assert_equal "balvig/capistrano-fiesta", parser.repo
    end
  end
end
