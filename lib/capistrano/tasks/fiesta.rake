namespace :fiesta do
  namespace :deploy do
    task :starting do
      on roles(:web) do
        releases = capture("ls #{File.join(fetch(:deploy_to), 'releases')}")
        if last_release = releases.split("\n").sort.last
          Capistrano::Fiesta::Report.new(last_release).run
        end
      end


      #releases = capture("ls #{File.join(fetch(:deploy_to), 'releases')}")
      #if this_host_last_release = releases.split("\t").sort.last
      ## Not a cold start
      #end
      #if fetch(:slack_run_starting)
      #run_locally do
      #end
      #end
    end

    task :finished do
      #if fetch(:slack_run_finished)
      #end
      #end
    end
  end
end

#after 'deploy:starting', 'fiesta:deploy:starting'
#after 'deploy:finished', 'fiesta:deploy:finished'
