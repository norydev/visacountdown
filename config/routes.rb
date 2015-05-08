Rails.application.routes.draw do
  get 'welcome/index'

  resources :periods

  devise_for :users

  root 'welcome#index'
end
