# frozen_string_literal: true

module Gencon50
  module Routes
    class Searchable < Blacklight::Routes::Searchable
      def call(mapper, _options = {})
        mapper.get "/", action: "index", as: "search"
        mapper.get "/advanced", action: "advanced_search", as: "advanced_search"
        mapper.get "/page_links", action: "page_links", as: "page_links"

        mapper.post ":id/track", action: "track", as: "track"
        mapper.get ":id/raw", action: "raw", as: "raw", defaults: { format: "json" }

        mapper.get "opensearch"
        mapper.get "suggest", as: "suggest_index"
        mapper.get "facet/:id", action: "facet", as: "facet"
        mapper.get "facet_suggest/:id/(:query_fragment)", action: "facet", as: "facet_suggest", defaults: { only_values: true }
      end
    end
  end
end
