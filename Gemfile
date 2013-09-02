source 'http://rubygems.org'

gem 'rails', '3.2.12'

gem 'mysql2'

gem 'rack'

gem 'rake'

# Deploy with Capistrano
gem 'capistrano'
# Sync assets
gem 'asset_sync'

gem 'airbrake'
gem 'aproxacs-s3sync'
gem 'acts_as_geocodable', :git => 'https://github.com/osaris/acts_as_geocodable', :branch => 'ar-whiteattributes-rails323'
gem 'acts-as-taggable-on'
gem 'authlogic'
gem 'carrierwave', :git => 'git://github.com/jnicklas/carrierwave.git', :ref => '719a13ce97'
gem 'daemons'
gem 'dalli'
gem 'delayed_job'
gem 'delayed_job_active_record', :git => 'https://github.com/collectiveidea/delayed_job_active_record.git', :ref => '44eb9e6c'
gem 'fog'
gem 'googlecharts'
gem 'graticule'
gem 'highline'
gem 'jquery-rails'
gem 'mini_magick'
gem 'newrelic_rpm'
gem 'prawn'
gem 'prawnto_2', :require => 'prawnto'
gem 'sass-rails-bootstrap', '2.1.1'
gem 'simple-navigation'
gem 'validates_timeliness'
gem 'will_paginate'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'libv8', '3.11.8.4'
  gem 'therubyracer', '0.11.0'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'yui-compressor'
end

group :development do
  gem 'mailcatcher'
  gem 'rails-erd'
  gem 'rspec-rails'
end

group :test do
  gem 'coveralls', :require => false
  # TODO upgrade when faker > 1.1.2 is released (1.1.2 is buggy with fr locale)
  gem 'faker', '1.0.1'
  gem 'machinist'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'shoulda-matchers'
end
