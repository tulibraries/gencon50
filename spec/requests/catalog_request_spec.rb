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

  context "default index" do
    before(:all) do
      VCR.configure do |config|
        config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
        config.hook_into :webmock
        config.default_cassette_options = {
          match_requests_on: [:method, VCR.request_matchers.uri_without_param(:key)]
        }
      end
    end

    subject {
      VCR.use_cassette("responseDefaultIndex", record: :none) do
        get "?search_field=all_fields&q="
      end
      response.body
    }

    describe "All fixture items" do
      it { is_expected.to include("14,425") }
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
      VCR.use_cassette("responseCatalogRecordPage", record: :none) do
        get "/catalog/2002-8084"
      end
      response.body
    }

    it { is_expected.to include("A Grimm World of Perilous Adventure") }
    it { is_expected.to include("1740") }
    it { is_expected.to include("2002-8084") }
    it { is_expected.to include("Hogshead Publishing Limited") }
    it { is_expected.to include("RP") }
    it { is_expected.to include("Warhammer Fantasy Roleplaying, A Grimm World of Perilous Adventure") }
    it { is_expected.to include("225") }
    it { is_expected.to include("S-1") }
  end

  context "search" do
    describe "all fields" do
      subject {
        VCR.use_cassette("responseSearchAllFields", record: :none) do
          get "?search_field=all_fields&q=Realms"
        end
        response.body
      }

      it { is_expected.to include("2012-BGM1237526") }
      it { is_expected.to include("2002-9036") }
    end

    describe "summary in all fields" do
      subject {
        search_text = URI::encode("Afrika Korps attacks US II Corps in 10th Annual Family Team Event")
        VCR.use_cassette("responseSummaryInAllFields", record: :none) do
          get "?search_field=all_fields&q=#{search_text}"
        end
        response.body
      }
      it { is_expected.to include("2012-HMN1230462") }
    end

    describe "Title Search" do
      subject {
        VCR.use_cassette("responseTitleSearch", record: :none) do
          get "?search_field=title&q=War+With+Asgard"
        end
        response.body
      }

      it { is_expected.to include("2012-RPG1229395") }
    end

    describe "Game System Search" do
      subject {
        VCR.use_cassette("responseGameSystemSearch", record: :none) do
          get "?search_field=game_system_t&q=Dungeons+%26+Dragons"
        end
        response.body
      }

      it { is_expected.to include("2012-RPG1231412") }
    end

    describe "Event Type Search" do
      subject {
        VCR.use_cassette("responseEventTypeSearch", record: :none) do
          get "?search_field=event_type_t&q=bg"
        end
        response.body
      }

      it { is_expected.to include("2002-1079") }
    end

    describe "Long Description Search" do
      subject {
        search_text = URI::encode("Imperial Japan invades Midway in three huge connected Air-Sea & Land Miniatures Battles")
        VCR.use_cassette("responseLongDescriptionSearch", record: :none) do
          get "?search_field=all_fields&q=" + search_text
        end
        response.body
      }

      it { is_expected.to include("2012-HMN1230465") }
    end

    describe "GM Name Search" do
      subject {
        VCR.use_cassette("responseGMNameSearch", record: :none) do
          get "?search_field=gm_names_t&q=charles"
        end
        response.body
      }

      it { is_expected.to include("2012-RPG1233561") }
    end

    describe "Group Search" do
      subject {
        VCR.use_cassette("responseGroupSearch", record: :none) do
          get "?search_field=group_t&q=smith"
        end
        response.body
      }

      it { is_expected.to include("2002-7292") }
    end

    describe "Location Search" do
      subject {
        VCR.use_cassette("responseLocationSearch", record: :none) do
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
        VCR.use_cassette("responseYearFacetSearch", record: :none) do
          get "?f[year_facet][]=2001"
        end
        response.body
      }

      it { is_expected.to include("2,559") }
    end

    describe "Group Facet Search" do
      subject {
        VCR.use_cassette("responseGroupFacetSearch", record: :none) do
          get "?f[group_facet][]=Fantasy+Flight+Games"
        end
        response.body
      }

      it { is_expected.to include("379") }
    end

    describe "Event Type Facet Search" do
      subject {
        VCR.use_cassette("responseEventTypeFacetSearch", record: :none) do
          get "?f[event_type_facet][]=NM"
        end
        response.body
      }

      it { is_expected.to include("335") }
    end

    describe "Game System Facet Search" do
      subject {
        VCR.use_cassette("responseGameSystemFacetSearch", record: :none) do
          get "?f[game_system_facet][]=Empire%20Builder"
        end
        response.body
      }

      it { is_expected.to include("79") }
    end
  end

  context "Embedded ID's in ID" do
    subject {
      VCR.use_cassette("responseEnbeddedIdsInIdSearch", record: :none) do
        get "/catalog/2001-2135%202136%202137%202138"
      end
      response.body
    }

    it { is_expected.to include("Pokemon") }
    it { is_expected.to include("2001-2135 2136 2137 2138") }
  end
end
