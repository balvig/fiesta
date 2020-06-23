namespace :fiesta do
  desc "Generate a fiesta report and announce it"
  task :run do
    if master_branch?
      invoke "fiesta:announce"
    end
  end

  desc "Announce a fiesta report"
  task :announce do
    run_locally do
      report = build_report
      report.announce(slack_params)
      Fiesta::Logger.logs.each { |log| warn log }
    end
  end

  def build_report
    Fiesta::Report.new(repo, report_options)
  end

  def repo
    Fiesta::RepoUrlParser.new(repo_url).repo
  end

  def report_options
    {
      current_revision: fetch(:current_revision),
      previous_revision: fetch(:previous_revision),
      comment: fetch(:fiesta_comment),
      auto_compose: fetch(:fiesta_auto_compose)
    }
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

after "deploy:finished", "fiesta:announce"
