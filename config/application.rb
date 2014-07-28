require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TipForTip
  class Application < Rails::Application

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += %W["#{config.root}/app/services/**/" "#{config.root}/app/validators/"]

    # Configure asset precompilation for heroku deployment
    config.assets.initialize_on_precompile = true

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # Middleware

    # Mail
    config.mandrill_mailer.default_url_options = { host: 'tipfortip.com', protocol: :https }
    config.mandrill_mailer.api_key = Rails.application.secrets.mandrill['api_key']

  end
end
