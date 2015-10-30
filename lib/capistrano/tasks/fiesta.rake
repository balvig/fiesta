namespace :fiesta do
  desc 'Generate a release report and post it on Slack'
  task :report do
    invoke 'fiesta:set_last_release'
    invoke 'fiesta:generate'
  end

  task :set_last_release do
    on roles(:web).first do
      last_release_path = capture("readlink #{current_path}")
      last_release = last_release_path.split('/').last
      set(:last_release, last_release)
    end
  end

  task :generate do
    run_locally do
      report = Capistrano::Fiesta::Report.create(repo_url, last_release: fetch(:last_release), comment: fetch(:fiesta_comment))
      report.announce(slack)
      report.create_release(fetch(:release_name)) if fetch(:branch) == 'master'
      Capistrano::Fiesta::Logger.logs.each { |log| warn log }
    end
  end

  def slack
    {
      team: fetch(:slack_team),
      token: fetch(:slack_token),
      webhook: fetch(:slack_webhook),
      via_slackbot: fetch(:slack_via_slackbot),
      channel: fetch(:fiesta_slack_channel)
    }
  end
end

before 'deploy:starting', 'fiesta:set_last_release'
after 'deploy:finished', 'fiesta:generate'
