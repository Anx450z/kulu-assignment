Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for :users, skip: [ :sessions ], controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  namespace :api do
    namespace :v1 do
      resource :sessions, only: [ :destroy ]
      resources :invites, only: %i[ index destroy ] do
        member do
          post :accept
        end
      end
      resources :tasks, only: %i[show destroy] do
        member do
          patch :assign_user
          patch :unassign_user
        end
      end
      resources :comments, only: %i[show update destroy] do
        member do
          post :like
        end
      end
      resources :task do
        resources :comments, only: %i[index create]
      end

      resources :projects do
        resources :invites, only: %i[show create]
        resources :tasks, only: %i[index create update]
      end
    end
  end
  # Defines the root path route ("/")
  root "home#index"
  # route all (except for active storage) get request through home#index so that react router can render page
  constraints ->(req) { !req.path.starts_with?("/rails/active_storage") } do
    get "*path", to: "home#index", via: :all
  end
end
