Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  get 'welcome/index'
  get 'welcome/empty_user'
  get 'welcome/calculator'
  get 'welcome/results'

  post 'welcome/user_details'
  post 'welcome/add_empty'
  post 'welcome/calculation'

  patch 'users/set_latest_location'
  put 'users/set_latest_location'
  patch 'users/set_citizenship'
  put 'users/set_citizenship'

  resources :periods

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root 'welcome#index'

end
