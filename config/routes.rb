Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #

  get '/status', to: 'application#api_status'

  post '/users', to: 'user#create'
  get '/users/:id', to: 'user#read'
  get '/users/:id/tweets', to: 'user#tweets'
  patch '/users/:id', to: 'user#update'
  delete '/users/:id', to: 'user#destroy'

  post '/sessions', to: 'session#create'
  delete '/sessions', to: 'session#destroy'

  scope '/tweets' do
    post '/', to: 'tweet#create'
    get '/', to: 'tweet#index'
    get '/:id',  to: 'tweet#read'
    patch '/:id', to: 'tweet#update'
    delete '/:id', to: 'tweet#destroy'
  end
end
