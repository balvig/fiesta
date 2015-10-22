# capistrano-fiesta

capistrano-fiesta integrates capistrano with GitHub pull requests and Slack, making
sharing release reports with the rest of the team a breeze.

When deploying, capistrano-fiesta will compile an editable list of merged pull
request titles since the last release, pulling out any images from the descriptions so they can be attached as screenshots:


## Installing

1. To get automated posting to Slack, first install [Slackistrano](https://github.com/phallstrom/slackistrano).
2. Add capistrano-fiesta to your application's Gemfile:

  ```ruby
  gem 'capistrano-fiesta'
  ```
3. Finally require in the capfile or appropriate stage and configure the slack channel

  ```ruby
  require 'capybara-fiesta'
  set :fiesta_slack_channel, '#release'
  ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/balvig/capistrano-fiesta.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

