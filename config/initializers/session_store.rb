# -*- encoding : utf-8 -*-
# Be sure to restart your server when you modify this file.

require 'action_dispatch/middleware/session/dalli_store'
Rails.application.config.session_store :dalli_store, :memcache_server => ['127.0.0.1'], :namespace => 'sessions', :key => '_spgestion_session', :expire_after => 30.minute

# SpGestion::Application.config.session_store :mem_cache_store, Memcache::Rails.new, :key => '_spgestion_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Rails3::Application.config.session_store :active_record_store
