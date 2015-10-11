require 'capistrano/bundler'
require "octokit"
require "yaml"

load File.expand_path("../tasks/fiesta.rake", __FILE__)

puts 'woooohoo'

module Capistrano
  module Fiesta
    def self.run
      hub_config_path = Dir.home + "/.config/hub"
      hub_config = YAML.load_file hub_config_path
      config = hub_config["github.com"].first

      Octokit.configure do |c|
        c.login = config["user"]
        c.access_token = config["oauth_token"]
      end

      repo = "cookpad/global-web"
      last_release = "2015-10-09"
      merged = ">=#{last_release}"

      Octokit.search_issues("base:master repo:#{repo} merged:#{merged}").items.each do |pr|
        title = pr.title.sub(/\[.+\]/, '')
        puts "- #{title}"
      end
    end
  end
end
