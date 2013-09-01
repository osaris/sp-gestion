# -*- encoding : utf-8 -*-
SpGestion::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  config.action_controller.asset_host = "http://" + SPG_CONFIG['fog']['directory']

  # Compress both stylesheets and javascripts
  config.assets.compress = true
  config.assets.css_compressor = :yui
  config.assets.js_compressor = :yui

  # Use digest to determine which files are updated (must have for asset_sync to work)
  config.assets.digest = true

  # Add asset tree
  config.assets.precompile += ['back-all.css','front-all.css',
                               'back.js','front.js']

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.base_url = SPG_CONFIG['base_url']
  config.google_application_id = SPG_CONFIG['google_application_id']

  # Configure emails
  config.action_mailer.default_url_options = { :host => "www." + config.base_url }
  config.action_mailer.delivery_method = SPG_CONFIG['delivery_method']
  config.action_mailer.smtp_settings = SPG_CONFIG['smtp_settings']
end
