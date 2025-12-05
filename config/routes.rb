Rails.application.routes.draw do
  devise_for :users

  root to: "shelves#index", as: :home
  get "/styletest", to: "pages#styletest"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  resources :shelves do
    collection do
      post :add_to_collection
    end
  end
  resources :books, only: [:show]
  resources :user_books, only: [:index, :edit, :update, :destroy], path: "my_books" do
    collection do
      post :add_to_library
    end
  end
  resources :searches, only: [:index]
  resources :shelf_books, only: [:create]
end
