set :application, "Boarrd"
set :repository,  "ssh://git@github.com/railsrumble/rr10-team-168.git"

set :scm, :git

server "boarrd.com", :app, :web, :db, :primary => true
#server "localhost", :app, :web, :db, :primary => true
#set :port, 51527
set :user, "boarrd"
set :password, "w3l41k4"
set :deploy_to, "/srv/www/li73-77.members.linode.com"
set :use_sudo, false
set :rails_env, 'production'
set :deploy_via, :remote_cache

namespace :deploy do
  task :update, :roles => :app do
    run "cd #{latest_release} && bundle install ../../shared/bundles/"
    run "cd #{latest_release} && bundle pack"

    # bundle & compress CSS
    run "cd #{latest_release} && rake assets:sass RAILS_ENV=#{rails_env}"

    # javascript i18n
    run "cd #{latest_release} && rake assets:js RAILS_ENV=#{rails_env}"

    # bundle & compress all the JS
    run "cd #{latest_release} && bundle exec jammit --output public/assets --config config/assets.yml --force"
  end

  task :update_db, :roles => :app do
    run "cd #{latest_release} && rake db:migrate RAILS_ENV=#{rails_env}"
  end

  task :reset_db, :roles => :app do
    run "cd #{latest_release} && rake db:drop RAILS_ENV=#{rails_env}"
    run "cd #{latest_release} && rake db:create RAILS_ENV=#{rails_env}"
    run "cd #{latest_release} && rake db:migrate RAILS_ENV=#{rails_env}"
  end

  task :finalize, :roles => :app do
    run "cd #{latest_release} && rake tmp:clear"
    #run "cd #{latest_release} && bundle exec whenever --update-crontab #{application} --set cron_log=#{shared_dir}/log/cron.log"
  end
end
