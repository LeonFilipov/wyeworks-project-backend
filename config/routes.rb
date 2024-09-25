Rails.application.routes.draw do
  get "availability_tutors/index"
  get "availability_tutors/show"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "auth/google_oauth2/callback" => "sessions#oauth2_callback"
  get "authorization" => "sessions#authorization_needed"

  resources :users, only: [ :index, :show ]
  get "profile" => "users#profile"
  put "profile" => "users#update"
  patch "profile" => "users#update"

  resources :universities, only: [ :index, :show ] do
    resources :subjects, only: [ :index, :show ] do
      resources :topics
    end
  end

  post "topics/:topic_id/tutor_availability" => "availability_tutors#create"

  resources :tutor_availability, only: [ :index, :show, :create ], controller: 'availability_tutors'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
