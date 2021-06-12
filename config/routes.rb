Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #

  get '/status', to: 'application#api_status'

  scope '/users' do
    post '/', to: 'user#create'
    get '/', to: 'user#search'
    get '/:id', to: 'user#read'
    get '/:id/tweets', to: 'user#tweets'
    patch '/:id', to: 'user#update'
    delete '/:id', to: 'user#destroy'
  end

  scope '/sessions' do
    get '/', to: 'session#current'
    post '/', to: 'session#create'
    delete '/', to: 'session#destroy'
  end

  scope '/tweets' do
    post '/', to: 'tweet#create'
    get '/:id',  to: 'tweet#read'
    patch '/:id', to: 'tweet#update'
    delete '/:id', to: 'tweet#destroy'

    post '/:id/like', to: 'likes#create'
    delete '/:id/like', to: 'likes#delete'
    get '/:id/like', to: 'likes#index'

    post '/:id/comment', to: 'comments#create'
    patch '/:id/comment', to: 'comments#edit'
    delete '/:id/comment', to: 'comments#delete'
  end

  scope '/comments' do
    post '/:id/like', to: 'comments#like'
    delete '/:id/like', to: 'comments#unlike'
  end

  scope '/following' do
    post '/:id/follow', to: 'following#create'
    delete '/:id/unfollow', to: 'following#destroy'

    get '/:user_id/followers', to: 'following#followers'
    get '/:user_id/following', to: 'following#following'
  end

  scope '/feed' do
    get '/', to: 'feed#index'
  end

  post '/upload', to: 'upload#create'
end
