Rails.application.routes.draw do

  ActiveAdmin.routes(self)

  get 'welcome/index'
  post 'welcome/user_details'

  post 'users/latest_entry'

  patch 'users/latest_entry'
  put 'users/latest_entry'

  resources :periods

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root 'welcome#index'

end
