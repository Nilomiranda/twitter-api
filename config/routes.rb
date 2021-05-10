Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #

  get '/status', to: 'application#api_status'

  post '/users', to: 'user#create'
  get '/users/:id', to: 'user#read'
  patch '/users/:id', to: 'user#update'
  delete '/users/:id', to: 'user#destroy'

  post '/sessions', to: 'session#create'
  delete '/sessions', to: 'session#destroy'
end
