namespace :fiesta do
  desc 'Run a fiesta report'
  task :run do
    invoke 'fiesta:generate'
    invoke 'fiesta:announce'
  end

  task :generate do
    run_locally do
      set :fiesta_report, Capistrano::Fiesta::Report.new(repo_url, last_release: last_release, comment: fetch(:fiesta_comment))
      info "Deploying #{report.stories.size} new story(ies)"
    end
  end

  task :announce do
    run_locally do
      report.announce(slack)
      report.create_release fetch(:release_timestamp) if fetch(:branch) == 'master'
      Capistrano::Fiesta::Logger.logs.each { |log| warn log }
    end
  end

  def report
    fetch(:fiesta_report)
  end

  def last_release
    last_release = nil
    on roles(:web).first do
      last_release_path = capture("readlink #{current_path}")
      last_release = last_release_path.split('/').last
    end
    last_release
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

before 'deploy:starting', 'fiesta:generate'
after 'deploy:finished', 'fiesta:announce'
