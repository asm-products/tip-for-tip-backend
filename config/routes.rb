require 'api_constraints'

Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'auth' }, path: ''
  devise_scope :user do
    get 'auth/logout', to: 'auth#destroy', as: :destroy_user_session, via: [:get, :delete, :post]
  end

  # ! A scope for now to add an /api segment.
  scope module: 'api', constraints: ApiConstraints.new(version: 1, default: :true), defaults: { format: :json } do

    get '/profile', to: 'users#profile'
    get '/account/balance', to: 'account#balance'
    get '/account/purchases', to: 'account#purchases'
    get '/account/sales', to: 'account#sales'

    namespace :nouns do
      get '/places/foursquare/:foursquare_id', to: 'places#foursquare_show', as: :foursquare_place
      get '/places/:place_id', to: 'places#show', as: :place

      get 'things/search', to: 'things#search', as: :things_search, constraints: SearchConstraint
      resources :things, only: [:show, :create], param: :thing_id
    end

    resource :tips, path: '/:noun_type/:noun_id/tips', only: :create

    get  '/tips/:tip_id' => 'tips#show', as: :tip
    post '/tips/:tip_id/purchase/:service' => 'purchases#create', as: :purchase_tip

    get '/partners/:partner_id' => 'partners#show', as: :partner
    get '/foursquare/*foursquare_path', to: 'foursquare#proxy'

  end

end
