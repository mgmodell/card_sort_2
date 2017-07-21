# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cs2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.google_key = '827079773701-dk8t2verhd2l08bqo12urbpg5a9gtgr1.apps.googleusercontent.com'
    config.google_secret = 'K3NKuCXiYHQ1J7aQmUqvbLSs'
    config.google_domain = 'accounts.google.com/o/'
  end
end
