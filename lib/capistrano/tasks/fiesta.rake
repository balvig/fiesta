namespace :fiesta do
  desc "Generate a fiesta report and announce it"
  task :run do
    invoke "fiesta:generate"
    invoke "fiesta:announce"
  end

  desc "Generate a fiesta report"
  task :generate do
    run_locally do
      info "Deploying #{report.stories.size} new story(ies)"
    end
  end

  desc "Announce a fiesta report"
  task :announce do
    run_locally do
      if master_branch?
        report.announce(slack_params)
        report.create_release(timestamp)
      end
      Capistrano::Fiesta::Logger.logs.each { |log| warn log }
    end
  end

  def report
    @_report ||= Capistrano::Fiesta::Report.new(repo_url, report_options)
  end

  def report_options
    {
      last_release: last_release,
      comment: fetch(:fiesta_comment),
      auto_compose: fetch(:fiesta_auto_compose)
    }
  end

  def last_release
    last_release = nil
    on roles(:web).first do
      last_release_path = capture("readlink #{current_path}")
      last_release = last_release_path.split("/").last
    end
    last_release
  end

  def master_branch?
    fetch(:branch) == "master"
  end

  def timestamp
    fetch(:release_timestamp)
  end

  def slack_params
    {
      team: fetch(:slack_team),
      token: fetch(:slack_token),
      webhook: fetch(:slack_webhook),
      via_slackbot: fetch(:slack_via_slackbot),
      payload: {
        channel: fetch(:fiesta_slack_channel) || "releases",
        username: fetch(:fiesta_slack_username) || "New Releases",
        icon_emoji: ":tada:"
      }
    }
  end
end

before "deploy:starting", "fiesta:generate"
after "deploy:finished", "fiesta:announce"
