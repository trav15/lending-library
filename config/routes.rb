Rails.application.routes.draw do

  root to: 'static#welcome'

  get '/auth/facebook/callback' => 'sessions#create'

  get '/items/stats', to: 'items#stats'

  resources :loans
  resources :items do
    resources :loans, only: [:new, :create]
  end

  resources :users, only: [:show] do
    resources :loans, only: [:new, :index, :update]
  end


  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

end
