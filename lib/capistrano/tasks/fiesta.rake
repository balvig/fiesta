
namespace :fiesta do
  desc 'Generate a release report for pasting in Slack'
  task :report do
    invoke 'fiesta:set_last_release'
    invoke 'fiesta:generate'
  end

  task :set_last_release do
    on roles(:web).first do
      releases = capture("ls #{releases_path}")
      last_release = releases.split("\n").sort.last
      set(:last_release, last_release)
    end
  end

  task :generate do
    run_locally do
      next warn 'Install Slackistrano to post Fiesta reports to Slack' unless defined?(Slackistrano)
      report = Capistrano::Fiesta::Report.new(repo_url, last_release: fetch(:last_release))
      result = report.write

      if !result.empty?
        Slackistrano.post(
          team: fetch(:slack_team),
          token: fetch(:slack_token),
          webhook: fetch(:slack_webhook),
          via_slackbot: fetch(:slack_via_slackbot),
          payload: {
            channel: fetch(:fiesta_slack_channel),
            username: 'New Releases',
            icon_emoji: ':tada:',
            text: result
          }
        )
      else
        report.logs.each { |log| warn log }
      end
    end
  end
end

before 'deploy:starting', 'fiesta:set_last_release'
after 'deploy:finished', 'fiesta:generate'
