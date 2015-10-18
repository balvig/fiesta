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
    info Capistrano::Fiesta::Report.new(repo_url, last_release: fetch(:last_release)).save
  end
end

before 'deploy:starting', 'fiesta:set_last_release'
after 'deploy:finished', 'fiesta:generate'
