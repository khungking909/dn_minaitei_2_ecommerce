# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "products#index"
    resources :products
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/logout", to: "sessions#destroy"
    resource :cart, only: %i[show create destroy update]
    resources :orders
    resources :accounts
    namespace :admin do
      resources :products
      resources :users
      resources :orders
      get "/statistics", to: "statistics#monthly_statistics", as: "monthly_statistics"
      get "/statistics/:month/:year", to: "statistics#monthly_statistics_detail", as: "monthly_statistics_detail"
    end
  end
end
