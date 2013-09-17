# -*- encoding : utf-8 -*-
SpGestion::Application.routes.draw do

  constraints(:subdomain => 'www') do
    get '/home' => 'pages#home', :as => :home
    get '/bye' => 'pages#bye', :as => :bye
    get '/signup' => 'stations#new', :as => :signup
    get '/' => 'pages#home', :as => :root_front
  end

  constraints(:subdomain => /.+/) do
    resource :account, :only => [:edit, :destroy] do
      member do
        put :update_owner
        put :update_settings
      end
    end

    resources :confirmations, :only => [:edit, :update]

    resources :convocations do
      member do
        post :email
      end
      resources :convocation_firemen, :only => [:show] do
        member do
          get :accept
        end
        collection do
          get :show_all
          get :edit_all
          put :update_all
        end
      end
    end

    resources :check_lists do
      member do
        post :copy
      end
      resources :items, :except => [:index]
    end

    resources :email_confirmations, :only => [:edit, :update]

    resources :firemen do
      collection do
        get :facebook
        get :resigned
        get :trainings
      end
      resources :fireman_trainings
    end
    get '/firemen/:id/stats/change_year/:type' => 'firemen#stats_change_year', :as => :firemen_stats_change_year
    get '/firemen/:id/stats/:year/:type' => 'firemen#stats', :as => :firemen_stats

    resources :groups

    resources :interventions
    get '/interventions/stats/change_year/:type' => 'interventions#stats_change_year', :as => :interventions_stats_change_year
    get '/interventions/stats/:year/:type' => 'interventions#stats', :as => :interventions_stats

    resources :intervention_roles

    resources :items, :only => [:expirings] do
      collection do
        get :expirings
      end
    end

    resources :messages, :only => [:index, :show, :mark_as_read] do
      member do
        post :mark_as_read
      end
    end

    resources :newsletters, :only => [:new, :create, :activate] do
      member do
        get :activate
      end
    end

    resources :password_resets, :only => [:new, :create, :edit, :update]

    get '/profile' => 'profiles#edit', :as => :profile
    patch '/profile/update' => 'profiles#update', :as => :update_profile

    resources :stations, :only => [:new, :create, :check] do
      collection do
        post :check
      end
    end

    resources :trainings

    resources :uniforms do
      collection do
        post :reset
      end
    end

    resources :users, :only => [:new, :create, :destroy, :index]
    resources :vehicles

    post '/login/authenticate' => 'user_sessions#create', :as => :authenticate
    get '/login' => 'user_sessions#new', :as => :login
    get '/logout' => 'user_sessions#destroy', :as => :logout
    get '/' => 'dashboard#index', :as => :root_back
    get '*url' => 'dashboard#index', :as => :error_404
  end
end
