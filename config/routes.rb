# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :accounts, only: :omniauth_callbacks, controllers: { omniauth_callbacks: "omniauthes" }
  scope "(:locale)", locale: /en|vi/ do
    root "products#index"
    resources :products, only: %i(index show) do
      resources :comments
    end

    resource :cart, only: %i(show create destroy update)
    resources :orders, only: %i(create show index) do
      member do
        patch "/cancel", to: "orders#cancel"
      end
    end
    devise_for :accounts, controllers: { sessions: "sessions", registrations: "accounts" }, skip: :omniauth_callbacks
    namespace :admin do
      resources :products
      resources :users
      resources :orders
      get "/statistics", to: "statistics#monthly_statistics", as: "monthly_statistics"
      get "/statistics/:month/:year", to: "statistics#monthly_statistics_detail", as: "monthly_statistics_detail"
    end
  end
end
