# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_mataka_session',
  :secret => 'f70658bbbf1b99f236f4fed931ff26d0f33c1d38cc0a2f2c942832360ffb7d5bb8f812a6afe31a19a9346deb4ca347b91826c8792246032038ada9a093b58794'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
