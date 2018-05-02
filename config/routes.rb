Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  get '/posts', to: 'home#posts'
  get '/posts/:id', to: 'posts#show', as: 'post'

  resources :categories

  resources :users do
    get '/follow', to: 'users#follow_user', as: 'follow'
    get '/unfollow', to: 'users#unfollow_user', as: 'unfollow'
    resources :posts do
      get '/like', to: 'posts#like'
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
