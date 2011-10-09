# -*- encoding : utf-8 -*-
SpGestion::Application.routes.draw do

  constraints(:subdomain => 'www') do
    match '/home' => 'pages#home', :as => :home
    match '/bye' => 'pages#bye', :as => :bye
    match '/signup' => 'stations#new', :as => :signup
    match '/' => 'pages#home', :as => :root_front

    # admin routes
    match "/admin" => redirect("/admin/dashboard")
    namespace :admin do
      match "help" => "base#help"
      resource :dashboard, :only => [:show], :controller => :dashboard
      resource :session, :only => [:new, :create, :destroy], :controller => :session
      resources :account, :only => [:new, :create, :show, :forgot_password] do
        collection { get :forgot_password }
      end
    end
    match ':controller(/:action(/:id(.:format)))', :controller => /admin\/[^\/]+/
  end

  constraints(:subdomain => /.+/) do
    resource :account, :only => [:edit, :destroy] do
      member do
        put :update_logo
        put :update_owner
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

    resources :items, :only => [:expirings] do
      collection do
        get :expirings
      end
    end

    resources :firemen do
      collection do
        get :facebook
        get :resigned
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

    match '/profile' => 'profiles#edit', :as => :profile
    match '/profile/update' => 'profiles#update', :as => :update_profile

    resources :interventions
    match '/interventions/stats/change_year/:type' => 'interventions#stats_change_year', :as => :interventions_stats_change_year
    match '/interventions/stats/:year/:type' => 'interventions#stats', :as => :interventions_stats

    resources :stations, :only => [:new, :create, :check] do
      collection do
        post :check
      end
    end

    resources :uniforms do
      collection do
        post :reset
      end
    end

    resources :users, :except => [:edit, :update]
    resources :vehicles

    match '/login/authenticate' => 'user_sessions#create', :as => :authenticate
    match '/login' => 'user_sessions#new', :as => :login
    match '/logout' => 'user_sessions#destroy', :as => :logout
    match '/' => 'dashboard#index', :as => :root_back
    match '*url' => 'dashboard#index', :as => :error_404
  end
end
