# capistrano-fiesta

capistrano-fiesta integrates capistrano with GitHub pull requests and makes
creating release reports to share with the rest of the team a breeze.

When deploying capistrano-fiesta will compile an editable list of merged pull
request titles since the last deploy, and also pull out any images
from the descriptions so they can be attached as screenshots.


## Usage

Add this line to your application's Gemfile:

```ruby
gem 'capistrano-fiesta'
```

Require in the capfile or appropriate stage:

```ruby
require 'capybara-fiesta
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/balvig/capistrano-fiesta.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

