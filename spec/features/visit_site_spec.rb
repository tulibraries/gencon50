require 'rails_helper'
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
        visit('/?utf8=%E2%9C%93&search_field=all_fields&q=')
      end
      expect(page).to have_text('160,391')
      expect(page).to have_text('2017-RPG17108625')
      expect(page).to have_text('2017-ANI17123255')
    end

    it "searches the title field" do
      VCR.use_cassette("titleSearch", record: :none) do
        visit('/?utf8=%E2%9C%93&search_field=title&q=tobruk')
      end
      expect(page).to have_text('1 - 6 of 6')
      expect(page).to have_text('1979-12')
      expect(page).to have_text('2005-HM00052')
      expect(page).to have_text('1996-270002')
      expect(page).to have_text('2010-HMN1014177')
      expect(page).to have_text('2005-HM00053')
      expect(page).to have_text('1997-270091')
    end

    it "searches text with facets " do
      VCR.use_cassette("facetAllFieldsSearch", record: :none) do
        visit('/?f%5Byear_facet%5D%5B%5D=2010&q=strat-o-matic+hockey&search_field=all_fields')
      end
      expect(page).to have_text('2010-BGM1011250')
    end
  end
end