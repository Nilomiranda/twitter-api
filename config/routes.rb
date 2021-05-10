Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #

  get '/status', to: 'application#api_status'

  post '/users', to: 'user#create'
  get '/users/:id', to: 'user#read'

  post '/sessions', to: 'session#create'
end
