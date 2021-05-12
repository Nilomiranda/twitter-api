Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #

  get '/status', to: 'application#api_status'

  scope '/users' do
    post '/', to: 'user#create'
    get '/:id', to: 'user#read'
    get '/:id/tweets', to: 'user#tweets'
    patch '/:id', to: 'user#update'
    delete '/:id', to: 'user#destroy'
  end

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
