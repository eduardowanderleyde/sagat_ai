Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      get "account/balance", to: "bank_accounts#balance"
      post "transactions", to: "transactions#create"
      post "scheduled_transactions", to: "scheduled_transactions#create"
      get "statement", to: "transactions#index"

      resources :users, only: [ :show, :update ]

      resources :bank_accounts, only: [ :show ] do
        get "balance", on: :member
        get "statement", on: :member
      end

      resources :transactions, only: [ :create, :index ] do
        collection do
          post "deposit"
        end
      end
    end
  end
end
