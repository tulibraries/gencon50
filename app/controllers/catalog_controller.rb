# frozen_string_literal: true

class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config|
    config.bootstrap_version = 5
    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response
    #
    ## Should the raw solr document endpoint (e.g. /catalog/:id/raw) be enabled
    # config.raw_endpoint.enabled = false

    #Remove Bookmarks links and forms
    config.index.document_actions.delete(:bookmark)
    config.show.document_actions.delete(:bookmark)
    config.navbar.partials.delete(:bookmark)

    # Remove search links from nav bar
    config.navbar.partials.delete(:search_history)
    config.navbar.partials.delete(:saved_searches)

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      qf: %w[title_t
           short_description_t
           long_description_t
           gm_names_t
           year_t
           also_runs_t
           prize_t
           group_t
           event_type_t
           game_system_t
           rules_edition_t
           age_required_t
           experience_required_t
           duration_t
           website_t
           room_name_t
           table_number_t
           special_category_t
           rules_complexity_t].join(" "),
      fl: "id,
           score,
           year_display,
           title_display,
           short_description_display,
           long_description_display",
      rows: 10
    }

    # solr path which will be added to solr base url before the other solr params.
    #config.solr_path = 'select'
    #config.document_solr_path = 'get'

    # items to show per page, each number in the array represent another option to choose from.
    #config.per_page = [10,20,50,100]

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
      qt: "document",
      ## These are hard-coded in the blacklight 'document' requestHandler
      fl: "*",
      rows: 1,
      q: "{!term f=id v=$id}"
    }

    # solr field configuration for search results/index views
    config.index.title_field = "title_display"
    config.index.display_type_field = "format"

    # solr field configuration for document/show views
    #config.show.title_field = 'title_display'
    #config.show.display_type_field = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large set of results)
    # :index_range can be an array or range of prefixes that will be used to create the navigation (note: It is case sensitive when searching values)

    config.add_facet_field "year_facet", label: "Year", sort: "index", limit: -1, solr_params: { "facet.mincount" => 1 }
    config.add_facet_field "group_facet", label: "Group", sort: "count", limit: 10, solr_params: { "facet.mincount" => 1 }
    config.add_facet_field "event_type_facet", label: "Event Type", sort: "count", limit: 10, solr_params: { "facet.mincount" => 1 }
    config.add_facet_field "game_system_facet", label: "Game System", sort: "count", limit: 10, solr_params: { "facet.mincount" => 1 }

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field "id", label: "ID"
    config.add_index_field "year_display", label: "Year"
    config.add_index_field "title_display", label: "Title"
    config.add_index_field "short_description_display", label: "Summary"
    config.add_index_field "long_description_display", label: "Description"

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field "title_display", label: "Title"
    config.add_show_field "guid_s", label: "GUID"
    config.add_show_field "year_display", label: "Year"
    config.add_show_field "original_order_display", label: "Original Order"
    config.add_show_field "also_runs_display", label: "Also Runs"
    config.add_show_field "prize_display", label: "Prize"
    config.add_show_field "game_id_display", label: "Game"
    config.add_show_field "group_display", label: "Group"
    config.add_show_field "short_description_display", label: "Short Description"
    config.add_show_field "long_description_display", label: "Long Description"
    config.add_show_field "event_type_display", label: "Event Type"
    config.add_show_field "game_system_display", label: "Game System"
    config.add_show_field "rules_edition_display", label: "Rules Edition"
    config.add_show_field "minimum_players_display", label: "Minimum Players"
    config.add_show_field "maximum_players_display", label: "Maximum Players"
    config.add_show_field "age_required_display", label: "Age Required"
    config.add_show_field "experience_required_display", label: "Experience Required"
    config.add_show_field "materials_provided_display", label: "Materials Provided"
    config.add_show_field "start_date_display", label: "Start Date"
    config.add_show_field "duration_display", label: "Duration"
    config.add_show_field "end_date_display", label: "End Date"
    config.add_show_field "gm_names_display", label: "Game Master Names"
    config.add_show_field "web_address_for_more_info_display", label: "Web Address For More Info"
    config.add_show_field "email_for_more_info_display", label: "Email For More Info"
    config.add_show_field "tournament_display", label: "Tournament"
    config.add_show_field "round_number_display", label: "Round Number"
    config.add_show_field "total_rounds_display", label: "Total Rounds"
    config.add_show_field "minimum_play_time_display", label: "Minimum Play Time"
    config.add_show_field "can_attendees_register_for_this_event_display", label: "Can Attendees Register For This Event"
    config.add_show_field "event_cost_display", label: "Event Cost"
    config.add_show_field "location_display", label: "Location"
    config.add_show_field "room_name_display", label: "Room Name"
    config.add_show_field "table_number_display", label: "Table Number"
    config.add_show_field "special_category_display", label: "Special Category"
    config.add_show_field "tickets_available_display", label: "Tickets Available"
    config.add_show_field "last_modified_display", label: "Last Modified"
    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field "all_fields", label: "All Fields"


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field("title") do |field|
      ## solr_parameters hash are sent to Solr as ordinary url query params.
      #field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      ## :solr_local_parameters will be sent using Solr LocalParams
      ## syntax, as eg {! qf=$title_qf }. This is neccesary to use
      ## Solr parameter de-referencing like $title_qf.
      ## See: http://wiki.apache.org/solr/LocalParams
      #field.solr_local_parameters = {
      #  qf: '$title_t',
      #  pf: '$title_t'
      #}

      field.solr_parameters = {
        qf: "title_t",
        pf: "title_t"
      }
    end

    config.add_search_field("game_system_t", label: "Game System") do |field|
      field.solr_parameters = {
        qf: "game_system_t",
        pf: "game_system_t"
      }
    end

    config.add_search_field("event_type_t", label: "Event Type") do |field|
      field.solr_parameters = {
        qf: "event_type_t",
        pf: "event_type_t"
      }
    end

    config.add_search_field("long_description_t", label: "Long Description") do |field|
      field.solr_parameters = {
        qf: "long_description_t",
        pf: "long_description_t"
      }
    end

    config.add_search_field("gm_names_t", label: "GM Names") do |field|
      field.solr_parameters = {
        qf: "gm_names_t",
        pf: "gm_names_t"
      }
    end

    config.add_search_field("group_t", label: "Group") do |field|
      field.solr_parameters = {
        qf: "group_t",
        pf: "group_t"
      }
    end

    config.add_search_field("location_t", label: "Location") do |field|
      field.solr_parameters = {
        qf: "location_t",
        pf: "location_t"
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field "score desc, year_sort desc, title_sort asc", label: "relevance"
    config.add_sort_field "year_sort desc, title_sort asc", label: "year"
    config.add_sort_field "title_sort asc, year_sort desc", label: "title"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = "suggest"
    # if the name of the solr.SuggestComponent provided in your solrcongig.xml is not the
    # default 'mySuggester', uncomment and provide it below
    # config.autocomplete_suggester = 'mySuggester'
  end
end
