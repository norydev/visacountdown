Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  resources :users, only: [:edit] do
    member do
      patch 'set_citizenship'
      put 'set_citizenship'
    end
  end

  resources :destinations, only: [:edit] do
    member do
      patch 'set_latest_entry'
      put 'set_latest_entry'
    end
  end

  resources :periods, except: [:index, :show]

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root 'dashboard#index'

end
