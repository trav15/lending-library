Rails.application.routes.draw do

  root to: 'static#welcome'

  get '/auth/facebook/callback' => 'sessions#create'

  resources :lends
  resources :items do
    resources :lends, only: [:create]
  end

  resources :users, only: [:show] do
    resources :lends, only: [:index, :update]
  end


  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

end
