namespace :fiesta do
  namespace :deploy do
    desc 'Just do it'
    task :starting do
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
