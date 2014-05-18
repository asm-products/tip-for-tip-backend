Rails.application.routes.draw do

  # match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  # devise_for :users

  devise_for :users, controllers: { omniauth_callbacks: 'auth' }, path: ''
  # get 'auth/logout', to: 'auth#destroy', as: :destroy_user_session, via: [:get, :delete, :post]


end
