# frozen_string_literal: true

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "blacklight", to: "blacklight/index.js", preload: true
pin_all_from "vendor/javascript/blacklight", under: "blacklight"
pin "@github/auto-complete-element", to: "@github--auto-complete-element.js" # @3.8.0
pin "@popperjs/core", to: "@popperjs--core.js", preload: true # @2.11.8
pin "bootstrap", preload: true # @5.3.7
pin "@github/combobox-nav", to: "@github--combobox-nav.js" # @2.3.1
