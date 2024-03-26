# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "products#index"
    resources :products
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/logout", to: "sessions#destroy"
    resources :accounts
    namespace :admin do
      resources :products
      resources :users
      resources :orders
    end
  end
end
