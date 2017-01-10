server '0.0.0.0', user: 'myuser', roles: [:web, :app, :db], primary: true, asset_host_syncher: true

set :rails_env, 'production'

set :application, 'sp-gestion.fr'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/home/path/to/application/#{fetch(:application)}"

set :repo_url, 'git@github.com:osaris/sp-gestion.git'
set :branch, 'master'

set :format, :pretty
set :log_level, :info
# set :pty, true

set :passenger_restart_with_sudo, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

# let newrelic track deploys
set :newrelic_license_key, ''
set :newrelic_appname, ''

# let rollbar track deploys
set :rollbar_token, ''
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

# set :newrelic_license_key, ''
# set :newrelic_appname, ''

SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"
