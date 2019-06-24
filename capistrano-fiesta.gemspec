# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/fiesta/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-fiesta"
  spec.version       = Capistrano::Fiesta::VERSION
  spec.authors       = ["Jens Balvig"]
  spec.email         = ["jens@balvig.com"]

  spec.summary       = %q{Celebrate your releases!}
  spec.description   = %q{Automatically creates a report of merged PRs since last deploy for pasting into slack}
  spec.homepage      = "https://github.com/balvig/capistrano-fiesta"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "attr_extras", "~> 5.2"
  spec.add_dependency "capistrano", "~> 3.1"
  spec.add_dependency "octokit", "~> 4.1"

  spec.add_development_dependency "bundler", ">= 1.10", "< 3"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-line"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "multi_json"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"
end
