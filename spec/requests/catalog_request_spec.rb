require 'rails_helper'

RSpec.describe "Catalogs", type: :request do

  let(:doc_id) { '2007020969' }
  let(:mock_response) { instance_double(Blacklight::Solr::Response) }
  let(:mock_document) { instance_double(SolrDocument, export_formats: {}) }
  let(:search_service) { instance_double(Blacklight::SearchService) }

  context "default index" do
    subject {
      get "?search_field=all_fields&q="
      response.body
    }

    describe "All fixture items" do
      it { is_expected.to include("14,506") }
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
      get "/catalog/2002-8084"
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
        get "?search_field=all_fields&q=Realms"
        response.body
      }

      it { is_expected.to include("2012-BGM1237524") }
      it { is_expected.to include("2002-9036") }
    end

    describe "summary in all fields" do
      subject {
        search_text = URI::encode("Afrika Korps attacks US II Corps in 10th Annual Family Team Event")
        get "?search_field=all_fields&q=#{search_text}"
        response.body
      }
      it { is_expected.to include("2012-HMN1230462") }
    end

    describe "Title Search" do
      subject {
        get "?search_field=title&q=War+With+Asgard"
        response.body
      }

      it { is_expected.to include("2012-RPG1229395") }
    end

    describe "Game System Search" do
      subject {
        get "?search_field=game_system_t&q=Dungeons+%26+Dragons"
        response.body
      }

      it { is_expected.to include("2012-RPG1231412") }
    end

    describe "Event Type Search" do
      subject {
        get "?search_field=event_type_t&q=bg"
        response.body
      }

      it { is_expected.to include("2002-1079") }
    end

    describe "Long Description Search" do
      subject {
        search_text = URI::encode("Imperial Japan invades Midway in three huge connected Air-Sea & Land Miniatures Battles")
        get "?search_field=all_fields&q=" + search_text
        response.body
      }

      it { is_expected.to include("2012-HMN1230465") }
    end

    describe "GM Name Search" do
      subject {
        get "?search_field=gm_names_t&q=charles"
        response.body
      }

      it { is_expected.to include("2012-RPG1233561") }
    end

    describe "Group Search" do
      subject {
        get "?search_field=group_t&q=smith"
        response.body
      }

      it { is_expected.to include("2002-7292") }
    end

    describe "Location Search" do
      subject {
        get "?search_field=location_t&q=marriott"
        response.body
      }

      it { is_expected.to include("2012-RPG1237794") }
    end
  end

  describe "Year Facet Search"
  describe "Gruop Facet Search"
  describe "Event Type Facet Search"
  describe "Game System Facet Search"


end
