Rails.application.routes.draw do

  get 'welcome/index'

  post 'users/latest_entry'

  resources :periods

  devise_for :users

  root 'welcome#index'
end
