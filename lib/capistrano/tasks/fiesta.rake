namespace :fiesta do
  desc "Generate a fiesta report and announce it"
  task :run do
    if master_branch?
      invoke "fiesta:generate"
      invoke "fiesta:announce"
    end
  end

  desc "Generate a fiesta report"
  task :generate do
    run_locally do
      set :fiesta_report, build_report
    end
  end

  desc "Announce a fiesta report"
  task :announce do
    run_locally do
      report.announce(slack_params)
      report.create_release(timestamp)
      Capistrano::Fiesta::Logger.logs.each { |log| warn log }
    end
  end

  def build_report
    Capistrano::Fiesta::Report.new(repo, report_options)
  end

  def repo
    RepoUrlParser.new(repo_url).repo
  end

  def report
    fetch(:fiesta_report)
  end

  def report_options
    {
      last_released_at: last_release,
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
      webhook: fetch(:slack_webhook),
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
