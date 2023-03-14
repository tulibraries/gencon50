# frozen_string_literal: true

require "rails_helper"
require "net/http"
require "webmock/rspec"
require "vcr"

RSpec.feature "VisitSites", type: :feature do
  context "Visit catalog" do
    before(:all) do
      VCR.configure do |config|
        config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
        config.hook_into :webmock
        config.default_cassette_options = {
          match_requests_on: [:method, VCR.request_matchers.uri_without_param(:key)]
        }
      end
    end

    it "performs default search" do
      VCR.use_cassette("defaultSearch", record: :none) do
        visit("/?utf8=%E2%9C%93&search_field=all_fields&q=")
      end
      expect(page).to have_text("14,776")
      expect(page).to have_text("2012-HMN1230463")
      expect(page).to have_text("2012-HMN1230462")
    end

    it "searches the title field" do
      VCR.use_cassette("titleSearch", record: :none) do
        visit("/?utf8=%E2%9C%93&search_field=title&q=bunny")
      end
      expect(page).to have_text("1 - 6 of 6")
      expect(page).to have_text("2012-ANI1239205")
      expect(page).to have_text("2012-ANI1239198")
      expect(page).to have_text("2002-8605")
      expect(page).to have_text("2002-1097")
      expect(page).to have_text("2002-1098")
      expect(page).to have_text("2002-1099")
    end

    it "searches text with facets " do
      VCR.use_cassette("facetAllFieldsSearch", record: :none) do
        visit("/?f%5Byear_facet%5D%5B%5D=2012&q=strat-o-matic+hockey&search_field=all_fields")
      end
      expect(page).to have_text("2012-BGM1234347")
    end
  end
end
