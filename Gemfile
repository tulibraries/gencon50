# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", "~> 7.2.2"

gem "blacklight", "~> 8.3"
gem "blimp", github: "tulibraries/blimp"
gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap"
gem "carrierwave", "~> 3.0.7"
gem "cssbundling-rails"
gem "csv"
gem "devise", "~> 4.7", ">= 4.7.1"
gem "devise-guests"
gem "dotenv-rails"
gem "drb"
gem "image_processing", "1.12.2"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "listen", "~> 3.5"
gem "nokogiri"
gem "puma", "~> 5.6.8"
gem "rsolr", ">= 1.0", "< 3"
gem "sassc-rails"
gem "sqlite3"
gem "uglifier", ">= 1.3.0"
gem "turbolinks", "~> 5"
gem "twitter-typeahead-rails", "0.11.1.pre.corejavascript"
gem "tzinfo", "~> 2.0"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "zeitwerk", "~> 2.3"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "mutex_m"
  gem "rubocop-rails", require: false
end

group :development do
  gem "brakeman"
  gem "pry-rails"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.1.0"
  gem "web-console", ">= 3.3.0"
  gem "webmock"
end

group :test do
  gem "capybara", ">= 3.36"
  gem "rspec"
  gem "rspec-rails"
  gem "vcr"
end
