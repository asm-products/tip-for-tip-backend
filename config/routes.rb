Rails.application.routes.draw do

  # match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  # devise_for :users

  devise_for :users, controllers: { omniauth_callbacks: 'provider_auth' }



end
