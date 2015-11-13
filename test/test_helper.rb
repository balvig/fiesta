require 'capistrano/fiesta/report'
require 'minitest/autorun'
require 'minitest/reporters'
require 'pry'

# Require support files
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

# Pretty colors
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
