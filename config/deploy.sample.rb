require 'new_relic/recipes'
require 'time'
require 'bundler/capistrano'

load 'deploy/assets'

set :application, "sp-gestion.fr"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/path/to/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, "git"
set :repository,  "git@github.com:osaris/sp-gestion.git"
set :branch, "master"

# SSH options
set :user, "myuser"

server "my.ip.address.here", :app, :web, :db, :primary => true, :asset_host_syncher => true

set :rails_env, :production

# Doesn't try to update timestamp of assets in public/ as we are using S3
set :normalize_asset_timestamps, false

# Hooks
after   "deploy",            "deploy:cleanup"
after   "deploy:migrations", "deploy:cleanup"

after   "deploy",            "newrelic:notice_deployment"
after   "deploy:migrations", "newrelic:notice_deployment"

# Passenger restart
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

# Delayed_job
set :monit_service_name, "spgestion-delayed_job"
namespace :delayed_job do
  desc "Stop the delayed_job process"
  task :stop, :roles => :app do
    run "sudo monit stop #{monit_service_name}"
  end

  desc "Start the delayed_job process"
  task :start, :roles => :app do
    run "sudo monit start #{monit_service_name}"
  end

  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    run "sudo monit restart #{monit_service_name}"
  end
end

after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

# Upload local configuration to server
desc "Upload configuration"
task :upload_configuration do
  upload(File.expand_path('../sp-gestion.yml', __FILE__), "#{release_path}/config/sp-gestion.yml")
end

before "deploy:assets:precompile", "upload_configuration"

# VCS Revision info
desc "Write current revision to app/views/layouts/_vcs_revision.html.erb"
task :publish_revision do
  run "cp #{release_path}/REVISION #{release_path}/app/views/layouts/_vcs_revision.html.erb"
end

before "deploy:create_symlink", "publish_revision"

# Change update date in humans.txt
desc "Change update date in humans.txt"
task :update_humanstxt do
  run "sed -i 's/LAST_UPDATE/#{Time.now.strftime("%Y-%m-%d")}/g' #{release_path}/public/humans.txt"
end

before "deploy:create_symlink", "update_humanstxt"

# Update CSS URL in static HTML files
desc "Update CSS URL in static HTML files"
task :update_css_url_html do
  css = capture("cd #{release_path} && ruby -rjson -e \"p JSON.parse(open('assets_manifest.json').read)['assets']['front-all.css']\"")
  ['404', '500', '503'].each do |file|
    run "sed -i 's/FRONT_ALL_CSS/#{css.chomp.delete('"')}/g' #{release_path}/public/#{file}.html"
  end
end

after "deploy:assets:precompile", "update_css_url_html"

# Maintenance mode
namespace :deploy do
  namespace :web do
    task :disable, :roles => :web do
      run "cp #{current_path}/public/503.html #{current_path}/public/maintenance.html"
    end

    task :enable, :roles => :web do
      run "rm #{current_path}/public/maintenance.html"
    end
  end
end
