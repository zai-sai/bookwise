Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # index
  get "/my_books", to: "user_books#index", as: "user_books"

  # edit
  get "/my_books/:id/edit", to: "user_books#edit", as: "edit_user_books"

  # update
  patch "/my_books/:id", to: "user_books#update", as: "user_book"
end
