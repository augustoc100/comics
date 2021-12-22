Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # get '/test/', to: 'test#index'
  root to: 'comics#index'
end
