# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

# Set Some Env Variables
ENV['MONGO_DB']                ||= 'padrino_app_dev'
ENV['SESSION_SECRET']          ||= 'session_secret'
ENV['SESSION_ID']              ||= 'session_id'

## Configure I18n
I18n.default_locale = :en

Padrino.before_load do
  # Dependencies
  Padrino.dependency_paths.unshift("#{Padrino.root}/config/initializers/*.rb")  
  
  # Load Locale
  I18n.load_path += Dir["#{File.dirname(__FILE__)}/../locale/*.yml"]
end

Padrino.load!
