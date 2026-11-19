# frozen_string_literal: true

BotChallengePage.configure do |config|
  config.enabled = ENV.fetch("TURNSTILE_ENABLED", "false") == "true"

  config.cf_turnstile_sitekey = ENV["TURNSTILE_SITE_KEY"]
  config.cf_turnstile_secret_key = ENV["TURNSTILE_SECRET_KEY"]

  if config.enabled &&
      (config.cf_turnstile_sitekey.blank? || config.cf_turnstile_secret_key.blank?)
    raise "Cloudflare Turnstile is enabled but credentials are missing"
  end
end
