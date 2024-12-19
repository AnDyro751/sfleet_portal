Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :maintenance_services, except: %i[ new edit ]
      resources :cars, except: %i[ new edit ]
    end

    devise_for :users, controllers: {
      sessions: "api/sessions"
    },
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
    }
  end

  devise_for :users

  resources :cars
  resources :maintenance_services

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
