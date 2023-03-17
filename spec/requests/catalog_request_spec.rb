# frozen_string_literal: true

require "rails_helper"
require "net/http"
require "webmock/rspec"
require "vcr"

RSpec.describe "Catalogs", type: :request do

  let(:doc_id) { "2007020969" }
  let(:mock_response) { instance_double(Blacklight::Solr::Response) }
  let(:mock_document) { instance_double(SolrDocument, export_formats: {}) }
  let(:search_service) { instance_double(Blacklight::SearchService) }

  before(:all) do
    VCR.configure do |config|
      vcr_mode = :none
      config.register_request_matcher :port do |request_1, request_2|
        URI(request_1.uri).host == URI(request_2.uri).host
        URI(request_1.uri).port == URI(request_2.uri).port
      end
      config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
      config.hook_into :webmock
      config.default_cassette_options = {
        match_requests_on: [:method, VCR.request_matchers.uri_without_param(:key)]
      }
    end
  end

  context "default index" do

    subject {
      VCR.use_cassette("responseDefaultIndex") do
        get "?search_field=all_fields&q="
      end
      response.body
    }

    describe "All fixture items" do
      it { is_expected.to include("14,776") }
    end

    describe "First Item" do
      it { is_expected.to include("2012-HMN1230463") }
      it { is_expected.to include("Blood and Guts Monty!") }
    end

    describe "Another item" do
      it { is_expected.to include("2012-ENT1229382") }
      it { is_expected.to include("Comic Book Comedy") }
    end

    describe "Last Item" do
      it { is_expected.to include("2012-HMN1230462") }
      it { is_expected.to include("Midway Mahem") }
      it { is_expected.to include("WWII 1942 - 70th Anniversary") }
    end
  end

  context "catalog record page" do
    subject {
      VCR.use_cassette("responseCatalogRecordPage") do
        get "/catalog/2002-8084"
      end
      response.body
    }

    it { is_expected.to include("A Grimm World of Perilous Adventure") }
    it { is_expected.to include("723") }
    it { is_expected.to include("2002-8084") }
    it { is_expected.to include("Hogshead Publishing Limited") }
    it { is_expected.to include("Roleplaying Games") }
    it { is_expected.to include("Warhammer Fantasy Roleplaying, A Grimm World of Perilous Adventure") }
    it { is_expected.to include("101C:5") }
  end

  context "search" do
    describe "all fields" do
      subject {
        VCR.use_cassette("responseSearchAllFields") do
          get "?search_field=all_fields&q=Realms"
        end
        response.body
      }

      it { is_expected.to include("2012-BGM1237526") }
      it { is_expected.to include("2002-9036") }
    end

    describe "summary in all fields" do
      subject {
        search_text = Addressable::URI.encode("Afrika Korps attacks US II Corps in 10th Annual Family Team Event")
        VCR.use_cassette("responseSummaryInAllFields") do
          get "?search_field=all_fields&q=#{search_text}"
        end
        response.body
      }
      it { is_expected.to include("2012-HMN1230462") }
    end

    describe "Title Search" do
      subject {
        VCR.use_cassette("responseTitleSearch") do
          get "?search_field=title&q=War+With+Asgard"
        end
        response.body
      }

      it { is_expected.to include("2012-RPG1229395") }
    end

    describe "Game System Search" do
      subject {
        VCR.use_cassette("responseGameSystemSearch") do
          get "?search_field=game_system_t&q=Dungeons+%26+Dragons"
        end
        response.body
      }

      it { is_expected.to include("2012-RPG1231412") }
    end

    describe "Event Type Search" do
      subject {
        VCR.use_cassette("responseEventTypeSearch") do
          get "?search_field=event_type_t&q=BGM+-+Board+Game"
        end
        response.body
      }

      it { is_expected.to include("2012-BGM1230015") }
    end

    describe "Long Description Search" do
      subject {
        search_text = Addressable::URI.encode("Imperial Japan invades Midway in three huge connected Air-Sea & Land Miniatures Battles")
        VCR.use_cassette("responseLongDescriptionSearch") do
          get "?search_field=all_fields&q=" + search_text
        end
        response.body
      }

      it { is_expected.to include("2012-HMN1230465") }
    end

    describe "GM Name Search" do
      subject {
        VCR.use_cassette("responseGMNameSearch") do
          get "?search_field=gm_names_t&q=charles"
        end
        response.body
      }

      it { is_expected.to include("2012-RPG1233561") }
    end

    describe "Group Search" do
      subject {
        VCR.use_cassette("responseGroupSearch") do
          get "?search_field=group_t&q=smith"
        end
        response.body
      }

      it { is_expected.to include("2012-ENT1233888") }
    end

    describe "Location Search" do
      subject {
        VCR.use_cassette("responseLocationSearch") do
          get "?search_field=location_t&q=marriott"
        end
        response.body
      }

      it { is_expected.to include("2012-RPG1237794") }
    end
  end

  context "facet" do
    describe "Year Facet Search" do
      subject {
        VCR.use_cassette("responseYearFacetSearch") do
          get "?f[year_facet][]=2001"
        end
        response.body
      }

      it { is_expected.to include("2,559") }
    end

    describe "Group Facet Search" do
      subject {
        VCR.use_cassette("responseGroupFacetSearch") do
          get "?f[group_facet][]=Fantasy+Flight+Games"
        end
        response.body
      }

      it { is_expected.to include("379") }
    end

    describe "Event Type Facet Search" do
      subject {
        VCR.use_cassette("responseEventTypeFacetSearch") do
          get "?f[event_type_facet][]=Non-Historical+Miniatures"
        end
        response.body
      }

      it { is_expected.to include("384") }
    end

    describe "Game System Facet Search" do
      subject {
        VCR.use_cassette("responseGameSystemFacetSearch") do
          get "?f[game_system_facet][]=Empire%20Builder"
        end
        response.body
      }

      it { is_expected.to include("79") }
    end
  end

  context "Embedded ID's in ID" do
    subject {
      VCR.use_cassette("responseEnbeddedIdsInIdSearch") do
        get "/catalog/2001-2135%202136%202137%202138"
      end
      response.body
    }

    it { is_expected.to include("Pokemon") }
    it { is_expected.to include("2001-2135 2136 2137 2138") }
  end
end
