# fiesta

fiesta helps integrate deployment tools with GitHub pull requests and Slack, making
sharing release reports with the rest of the team a breeze.

When deploying, fiesta will compile an editable list of pull
requests merged to master since the last release, pulling out any images from the descriptions so they can be attached as screenshots:

<img src="https://cloud.githubusercontent.com/assets/104138/10676263/57b6bb44-7905-11e5-8df3-38e96a2a0685.png" width="60%" />

The edited content will be posted to Slack:

<img src="https://cloud.githubusercontent.com/assets/104138/10676270/63f627b4-7905-11e5-88e7-b60c08aada99.png" width="60%" />

## Usage

Build a new report for the release:

```ruby
report = Fiesta::Report.new('balvig/fiesta', {
  last_released_at: '20180920074104',
  comment: 'Only include new features',
  auto_compose: true,
})
```

Annouce the report to the Slack channel:

```ruby
report.announce(
  webhook: 'https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX',
  payload: {
    channel: '#release',
    username: 'New Releases',
    icon_emoji: ':tada:'
  }
)
```

Save the report as a GitHub release:

```ruby
report.create_release('20180927145914')
```

## Integrating with Capistrano

fiesta provides integration with Capistrano by default.

1. Add fiesta to your application's Gemfile:

  ```ruby
  gem 'fiesta'
  ```
2. Require in the capfile or appropriate stage and configure the Slack channel:

  ```ruby
  require 'capistrano/fiesta'
  set :fiesta_slack_channel, '#release'
  set :slack_webhook 'https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX'
  ```
3. If you're using [hub](https://github.com/github/hub) or [pt-flow](https://github.com/balvig/pt-flow), your GitHub credentials should already be configured. Otherwise you can use the [ENV vars in Octokit](https://github.com/octokit/octokit.rb/blob/a98979107a4bf9741a05a1f751405f8a29f29b38/lib/octokit/default.rb#L42-L156) to configure GitHub access.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/balvig/fiesta.
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

