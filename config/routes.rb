Rails.application.routes.draw do

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # To make the tests on kitt happy
  get "/404", to: "errors#not_found"
  get "/500", to: "errors#internal_server_error"

  devise_for :users

  root to: "shelves#index", as: :home
  get "/styletest", to: "pages#styletest"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  resources :shelves, except: [:edit] do
    collection do
      post :add_to_collection
    end
  end

  resources :books, only: [:index, :show]
  resources :user_books, only: [:index, :edit, :update, :destroy, :patch], path: "my_books" do
    collection do
      post :add_to_library
    end
  end

  resources :searches, only: [:index]
  resources :shelf_books, only: [:create, :destroy]
end
