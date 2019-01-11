Rails.application.routes.draw do

  root to: 'items#index'

  resources :items

  resources :users, only: [:new, :create, :show] do
    resources :lends, only: [:create]
  end

  resources :sessions, only: [:new, :create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
