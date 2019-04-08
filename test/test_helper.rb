# Set dummy ENV
ENV["OCTOKIT_ACCESS_TOKEN"] = "token-value"

# Require files to test
require 'capistrano/fiesta/repo_url_parser'
require 'capistrano/fiesta/report'

# Additional tooling
require 'minitest/autorun'
require 'minitest/reporters'
require 'pry'

# Require support files
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

# Pretty colors
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
