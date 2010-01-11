# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  # config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  config.i18n.default_locale = :fr
  config.i18n.exception_handler = :missing_translations_handler
  
  config.action_controller.session_store = :mem_cache_store
  config.action_controller.session = {:key => '_spgestion_session',
                                      :secret => "41da19045c1289f045a2797ace137c01908f49d5522ade1da1549022bd40202d663891fbca9dfc4d0f7a092e36ff5b325d38fe6cb22055d843802f37228c1868"}
  
  config.gm "authlogic",           :version => "2.1.3"
  config.gem "google_analytics",    :version => "1.1.5", :lib => "rubaidh/google_analytics", :source => "http://gems.github.com"
  config.gem "prawn",               :version => "0.7.1", :lib => "prawn"
  config.gem "simple-navigation",   :version => "2.1.0", :lib => 'simple_navigation', :source => "http://gemcutter.org/"
  config.gem "validates_timeliness",:version => "2.2.2"
  config.gem "will_paginate",       :version => "2.3.11", :source => "http://gemcutter.org/"
end

# Google Analytics configuration
Rubaidh::GoogleAnalytics.tracker_id = "UA-1194205-7"
Rubaidh::GoogleAnalytics.domain_name  = "sp-gestion.fr"
Rubaidh::GoogleAnalytics.environments = ["production"]
