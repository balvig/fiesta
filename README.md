# capistrano-fiesta

capistrano-fiesta integrates capistrano with GitHub pull requests and Slack, making
sharing release reports with the rest of the team a breeze.

When deploying, capistrano-fiesta will compile an editable list of pull
requests merged to master since the last release, pulling out any images from the descriptions so they can be attached as screenshots:

<img src="https://cloud.githubusercontent.com/assets/104138/10676263/57b6bb44-7905-11e5-8df3-38e96a2a0685.png" width="60%" />

The edited content will be posted to Slack:

<img src="https://cloud.githubusercontent.com/assets/104138/10676270/63f627b4-7905-11e5-88e7-b60c08aada99.png" width="60%" />


## Installing

1. To get automated posting to Slack, first install [Slackistrano](https://github.com/phallstrom/slackistrano).
2. Add capistrano-fiesta to your application's Gemfile:

  ```ruby
  gem 'capistrano-fiesta'
  ```
3. Require in the capfile or appropriate stage and configure the Slack channel:

  ```ruby
  require 'capybara-fiesta'
  set :fiesta_slack_channel, '#release'
  ```
4. If you're using [hub](https://github.com/github/hub) or [pt-flow](https://github.com/balvig/pt-flow), your GitHub credentials should already be configured. Otherwise you can use the [ENV vars in Octokit](https://github.com/octokit/octokit.rb/blob/a98979107a4bf9741a05a1f751405f8a29f29b38/lib/octokit/default.rb#L42-L156) to configure GitHub access.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/balvig/capistrano-fiesta.
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

