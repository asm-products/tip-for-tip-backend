require 'api_constraints'

Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'auth' }, path: ''
  devise_scope :user do
    get 'auth/logout', to: 'auth#destroy', as: :destroy_user_session, via: [:get, :delete, :post]
  end

  scope module: 'api', constraints: ApiConstraints.new(version: 1, default: :true), defaults: { format: :json } do

    get '/profile', to: 'users#profile'

    get '/foursquare/*foursquare_path', to: 'foursquare#proxy'

  end

end
