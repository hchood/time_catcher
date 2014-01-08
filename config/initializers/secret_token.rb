# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
TimeCatcherCapybara::Application.config.secret_key_base = ENV[SECRET_KEY]

# 'd8daeece4ccd8a64c7a5369c20009c183fe6cec9049063038ca3d9feb970c35721f02fa6a3e18bfc10ac2e23eb963c1ec2edf41cbf5e28018b52c8ccca83b83d'
