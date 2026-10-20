# frozen_string_literal: true

require "rails_helper"
require "active_support/testing/time_helpers"

RSpec.describe "Catalog Turnstile protection", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:challenge_controller) { BotChallengePage::BotChallengePageController }
  let(:challenge_config) { challenge_controller.bot_challenge_config }

  around do |example|
    original_enabled = challenge_config.enabled
    challenge_config.enabled = true

    example.run
  ensure
    challenge_config.enabled = original_enabled
  end

  describe "GET /catalog" do
    it "challenges an unverified request before searching Solr" do
      expect_any_instance_of(Blacklight::SearchService)
        .not_to receive(:search_results)

      get "/catalog"

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /catalog/:id" do
    it "challenges an unverified request before fetching a document" do
      expect_any_instance_of(Blacklight::SearchService)
        .not_to receive(:fetch)

      get "/catalog/example"

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "POST /challenge" do
    it "allows a verified session to access the catalog" do
      verification_response = instance_double(
        HTTP::Response,
        parse: { "success" => true }
      )

      allow_any_instance_of(HTTP::Session)
        .to receive(:post)
        .with(
          challenge_config.cf_turnstile_validation_url,
          hash_including(json: hash_including(response: "test-token"))
        )
        .and_return(verification_response)

      post "/challenge", params: {
        cf_turnstile_response: "test-token"
      }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["success"]).to be(true)

      allow_any_instance_of(CatalogController)
        .to receive(:index) do |controller|
          controller.head(:ok)
        end

      get "/catalog"

      expect(response).to have_http_status(:ok)
    end

    it "challenges a verified session after 24 hours" do
      verification_response = instance_double(
        HTTP::Response,
        parse: { "success" => true }
      )

      allow_any_instance_of(HTTP::Session)
        .to receive(:post)
        .with(
          challenge_config.cf_turnstile_validation_url,
          hash_including(json: hash_including(response: "test-token"))
        )
        .and_return(verification_response)

      travel_to(Time.utc(2026, 10, 20, 12)) do
        post "/challenge", params: {
          cf_turnstile_response: "test-token"
        }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["success"]).to be(true)

        travel 25.hours

        expect_any_instance_of(Blacklight::SearchService)
          .not_to receive(:search_results)

        get "/catalog"

        expect(response).to have_http_status(:forbidden)
      end
    end

    it "challenges a verified session when its fingerprint changes" do
      verification_response = instance_double(
        HTTP::Response,
        parse: { "success" => true }
      )

      allow_any_instance_of(HTTP::Session)
        .to receive(:post)
        .with(
          challenge_config.cf_turnstile_validation_url,
          hash_including(json: hash_including(response: "test-token"))
        )
        .and_return(verification_response)

      post "/challenge",
        params: { cf_turnstile_response: "test-token" },
        headers: { "User-Agent" => "OriginalBrowser/1.0" }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["success"]).to be(true)

      expect_any_instance_of(Blacklight::SearchService)
        .not_to receive(:search_results)

      get "/catalog",
        headers: { "User-Agent" => "DifferentBrowser/2.0" }

      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "when Turnstile is disabled" do
    it "allows catalog requests without a challenge" do
      challenge_config.enabled = false

      allow_any_instance_of(CatalogController)
        .to receive(:index) do |controller|
          controller.head(:ok)
        end

      get "/catalog"

      expect(response).to have_http_status(:ok)
    end
  end
end
