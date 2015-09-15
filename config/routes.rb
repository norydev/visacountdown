Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  get 'welcome/index'
  get 'welcome/empty_user'
  get 'welcome/calculator'
  get 'welcome/results'

  post 'welcome/user_details'
  post 'welcome/add_empty'
  post 'welcome/calculation'

  resources :users, only: [:show, :edit] do
    member do
      patch 'set_latest_location'
      put 'set_latest_location'
      patch 'set_citizenship'
      put 'set_citizenship'
    end
  end

  resources :periods

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root 'welcome#index'

end
