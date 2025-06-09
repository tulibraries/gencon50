# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Rails.load

module Blgencon
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    begin
      # Tell rails the applicaiton will be served from a subdirectory.
      config.relative_url_root = config_for(:deploy_to)["path"]
    rescue
      # Do nothing and expect the application to be server in root path.
    end
  end
end
