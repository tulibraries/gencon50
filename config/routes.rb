# frozen_string_literal: true

require Rails.root.join("lib/gencon50/routes/searchable")

Rails.application.routes.draw do
  post "/challenge", to: "bot_challenge_page/bot_challenge_page#verify_challenge", as: :bot_detect_challenge

  devise_for :users
  mount Blacklight::Engine => "/"
  root to: "catalog#index"
  concern :searchable, Gencon50::Routes::Searchable.new

  resource :catalog, only: [], as: "catalog", path: "/catalog", controller: "catalog" do
    concerns :searchable
  end

  resources :solr_documents, only: [:show], path: "/catalog", controller: "catalog"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
