# Be sure to restart your server when you modify this file.

SpGestion::Application.config.session_store :mem_cache_store, :namespace => 'sessions', :key => '_spgestion_session', :expire_after => 30.minute
