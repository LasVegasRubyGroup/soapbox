# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

if Rails.env.production?
  Soapbox::Application.config.secret_token = ENV['APP_SECRET_TOKEN']
else
  Soapbox::Application.config.secret_token = 'a24c14fbbd7b61f1734e042eacedc50312e26396e7242e803f9aa7b1e37f5c63b1251460d7ac63660157803e7dd4fbdbf6940998a37c83f0bb3e4a3564dfb5f5'
end


