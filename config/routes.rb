Rails.application.routes.draw do
  resources :periods

  devise_for :users

  # root 'periods#index'
end
