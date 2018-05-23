Rails.application.routes.draw do
  root to: 'home#posts'
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  get '/posts', to: 'home#posts'
  get '/activity', to: 'home#index'
  get '/posts/:id', to: 'posts#show', as: 'post'
  get '/search', to: 'search#search', as: 'search'
  get '/search/action', to: 'search#action', as: 'searchaction'
  get '/search/posts/:query', to: 'search#posts', as: 'searchposts'
  get '/search/post/:post_id', to: 'search#post', as: 'searchpost'
  get '/search/users/:query', to: 'search#users', as: 'searchusers'
  get '/search/user/:user_id', to: 'search#user', as: 'searchuser'
  get '/search/categories/:query', to: 'search#categories', as: 'searchcategories'
  get '/search/category/:category_id', to: 'search#category', as: 'searchcategory'



  resources :categories do
    get '/posts', to: 'categories#posts'
  end

  resources :users do
    get '/follow', to: 'users#follow_user', as: 'follow'
    get '/unfollow', to: 'users#unfollow_user', as: 'unfollow'
    get '/comments', to: 'comments#index', as: 'comments'
    get '/followers', to: 'users#followers', as: 'followers'
    get '/following', to: 'users#following', as: 'following'
    resources :posts do
      get '/like', to: 'posts#like'
      get '/publish', to: 'posts#publish'
      get '/unpublish', to: 'posts#unpublish'
      resources :comments do
        resources :comments
      end
    end
  end



  get 'oauth/login', to: redirect('/auth/google_oauth2'), as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
