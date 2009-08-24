# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sp-gestion_session',
  :secret      => '00e4489225ddaa82d424a8d11eb55fd9989b827f258343cc24afe1408171eeafed152eb4dab17783e03dd36bbdbbc3897b2f890b69f197a8a977e98c01ffccc1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
