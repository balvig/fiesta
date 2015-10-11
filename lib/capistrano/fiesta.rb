require "capistrano/fiesta/version"
require 'octokit'
require 'yaml'

module Capistrano
  module Fiesta
    # Your code goes here...
  end
end

hub_config_path = Dir.home + "/.config/hub"
hub_config = YAML.load_file hub_config_path
config = hub_config['github.com'].first

Octokit.configure do |c|
  c.login = config['user']
  c.access_token = config['oauth_token']
end

repo = 'cookpad/global-web'
last_release = '2015-10-09'
merged = ">=#{last_release}"

Octokit.search_issues("repo:#{repo} base:master merged:#{merged}").items.each do |pr|
  title = pr.title.sub(/\[.+\]/, '')
  puts "- #{title}"
end
