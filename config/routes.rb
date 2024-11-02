Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "auth/google_oauth2/callback" => "sessions#oauth2_callback"

  ## meets
  resources :meets, only: [ :index, :show, :update ]
  post "meets/:id/interesteds", to: "meets#add_interest"
  delete "meets/:id/interesteds", to: "meets#remove_interest"

  resources :topics, only: [ :index, :show, :create, :delete ]

  get "interested_meetings", to: "students#interested_meetings"
  # Temas propuestos
  get "proposed_topics", to: "topics#proposed_topics"
  get "proposed_topics/:availability_id", to: "topics#show"

  get "universities/:id/careers", to: "universities#careers"

  get "fake_user" => "users#fake_user"

  resources :universities, only: [ :index, :show ]

  scope :profile do
    get "/", to: "users#profile", as: :profile
    put "/", to: "users#update"
    patch "/", to: "users#update"
    # get "meets", to: "meets#my_meets"
    # match "meets/:id", to: "meets#my_meet", via: [ :get, :patch ] # GET y PATCH para el mismo endpoint
  end

  post "students/topics/:topic_id/request_topic" => "students#request_topic"

  get "students/my_requested_topics" => "students#my_requested_topics"
  get "students/requested_topics" => "students#requested_topics"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
