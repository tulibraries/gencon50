require 'rails_helper'

RSpec.describe "Catalogs", type: :request do

  let(:doc_id) { '2007020969' }
  let(:mock_response) { instance_double(Blacklight::Solr::Response) }
  let(:mock_document) { instance_double(SolrDocument, export_formats: {}) }
  let(:search_service) { instance_double(Blacklight::SearchService) }

  it "index page" do
    get "?search_field=all_fields&q="
    expect(response.body).to include("10mm Napoleonics")
  end

  describe "Show a document" do
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

  describe "Search all fields" do
    subject {
      get "?utf8=%E2%9C%93&f%5Bevent_type_facet%5D%5B%5D=SM&search_field=all_fields&q=Realms"
      response.body
    }

    it { is_expected.to include("A Forgotten Realms Celebration") }
    it { is_expected.to include("2002-9036") }
    it { is_expected.to include("What&#39;s New in the Forgotten Realms?") }
    it { is_expected.to include("2002-9025") }
  end

  describe "Title Search"
  describe "Game System Search"
  describe "Event Type Search"
  describe "Title Search"
  describe "Long Description Search"
  describe "GM Name Search"
  describe "Group Search"
  describe "Location Search"

  describe "Year Facet Search"
  describe "Gruop Facet Search"
  describe "Event Type Facet Search"
  describe "Game System Facet Search"


end
