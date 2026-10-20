# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Catalog routes", type: :routing do
  it "routes GET catalog searches" do
    expect(get: "/catalog").to route_to("catalog#index")
  end

  it "rejects POST catalog searches" do
    expect(post: "/catalog").not_to be_routable
  end

  it "routes GET catalog records" do
    expect(get: "/catalog/2002-8084").to route_to(
      "catalog#show", id: "2002-8084"
    )
  end

  it "routes GET facets" do
    expect(get: "/catalog/facet/year_facet").to route_to(
      "catalog#facet", id: "year_facet"
    )
  end

  it "routes GET autocomplete suggestions" do
    expect(get: "/catalog/suggest").to route_to("catalog#suggest")
  end

  it "preserves POST tracking" do
    expect(post: "/catalog/2002-8084/track").to route_to(
      "catalog#track", id: "2002-8084"
    )
  end
end
