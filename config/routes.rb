Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home", as: :home
  get "/styletest", to: "pages#styletest"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  resources :shelves, only: [:new, :create, :edit]
  resources :books, only: [:show]
  resources :user_books, only: [:index, :edit, :update, :destroy], path: "my_books"
end
