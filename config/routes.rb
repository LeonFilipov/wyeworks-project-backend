Rails.application.routes.draw do
  get "availability_tutors/index"
  get "availability_tutors/show"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "auth/google_oauth2/callback" => "sessions#oauth2_callback"
  get "authorization" => "sessions#authorization_needed"

  # resources :users, only: [ :index, :show ]
  # get "profile" => "users#profile"
  # put "profile" => "users#update"
  # patch "profile" => "users#update"
  
  resources :users, only: [ :index, :show, :create ] do
    member do
      get "proposed_topics", to: "topics#proposed_topics"
      get "proposed_topics/:topic_id", to: "topics#proposed_topic"
    end
  end

  scope :profile do
    get "/", to: "users#profile", as: :profile
    put "/", to: "users#update"
    patch "/", to: "users#update"
  end

  resources :universities, only: [ :index, :show, :create ] do
    resources :subjects, only: [ :index, :show, :create ] do
      resources :topics
    end
  end

  post "students/topics/:topic_id/request_topic" => "students#request_topic"

  get "students/my_requested_topics" => "students#my_requested_topics"
  get "students/requested_topics" => "students#requested_topics"
  post "topics/:topic_id/tutor_availability" => "availability_tutors#create"

  # resources :tutor_availability, only: [ :index, :show, :create ], controller: "availability_tutors" do
  #   resources :interesteds, only: [ :index, :show, :create, :destroy]
  # end

  # Routes for availability_tutors, including adding interest
  resources :tutor_availability, only: [ :index, :show, :create ], controller: "availability_tutors" do
    member do
      post "interesteds", to: "availability_tutors#add_interest"
    end
    resources :meets, only: [ :index, :show ] # Nested meet routes under availability_tutors
    resources :interesteds, only: [ :index, :show ] # Nested interested routes under availability_tutors
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
