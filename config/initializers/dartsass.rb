# frozen_string_literal: true

Rails.application.configure do
  bootstrap_stylesheets = File.join(Gem.loaded_specs.fetch("bootstrap").full_gem_path, "assets/stylesheets")
  blacklight_stylesheets = File.join(Gem.loaded_specs.fetch("blacklight").full_gem_path, "app/assets/stylesheets")

  config.dartsass.builds = {
    "application.scss" => "application.css"
  }

  config.dartsass.build_options = [
    "--load-path=#{bootstrap_stylesheets}",
    "--load-path=#{blacklight_stylesheets}"
  ]
end
