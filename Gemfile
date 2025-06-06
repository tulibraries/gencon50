# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.1.7.6"
# Use Puma as the app server
gem "puma", "~> 5.6.8"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"
# Use Uglifier as compressor for JavaScript assets
gem "sqlite3"
gem "uglifier", ">= 1.3.0"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem "coffee-rails", "~> 4.2"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.5"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

gem "listen", ">= 3.0.5", "< 3.2"
group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "brakeman"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 3.36"
  gem "rspec"
  gem "rspec-rails"
  gem "vcr"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Blacklight
gem "blacklight", "~> 8.3"

group :development, :test do
  gem "solr_wrapper", ">= 4.0.2"
  gem "webmock"
  gem "pry-rails"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
end

gem "rsolr", ">= 1.0", "< 3"
gem "bootstrap", "~> 4.0"
gem "twitter-typeahead-rails", "0.11.1.pre.corejavascript"
gem "jquery-rails"
gem "carrierwave", "~> 3.0.7"
gem "devise", "~> 4.7", ">= 4.7.1"
gem "devise-guests"
gem "blimp", github: "tulibraries/blimp"
gem "dotenv-rails"
gem "nokogiri"
gem "image_processing", "1.12.2"
