ActionController::Routing::Routes.draw do |map|

  Typus::Routes.draw(map)

  # map.account   '/account', :controller => 'accounts', :action => 'edit', :conditions => { :subdomain => /.+/  }, :method => :get
  # map.update_account_logo '/account/update_logo', :controller => 'accounts', :action => 'update_logo', :conditions => { :subdomain => /.+/ }, :method => :put
  # map.update_account_owner '/account/update_owner', :controller => 'accounts', :action => 'update_owner', :conditions => { :subdomain => /.+/  }, :method => :put
  # map.destroy_account '/account/destroy', :controller => 'accounts', :action => 'destroy', :conditions => { :subdomain => /.+/  }
  map.resource  :account, :only => [:edit, :destroy], :member => { :update_logo => :put, :update_owner => :put },  :conditions => { :subdomain => /.+/ }
  map.resources :confirmations, :only => [:edit, :update], :conditions => { :subdomain => /.+/ }
  map.resources :convocations, :member => { :email => :post}, :conditions => { :subdomain => /.+/  } do |convocation|
    convocation.resources :convocation_firemen, :only => [:show], :collection => {:show_all => :get, :edit_all => :get, :update_all => :put}, :conditions => { :subdomain => /.+/  }
  end
  map.resources :check_lists, :member => { :copy => :post }, :conditions => { :subdomain => /.+/ } do |check_list|
    check_list.resources :items, :except => [:index, :show], :conditions => { :subdomain => /.+/ }
  end
  map.resources :email_confirmations, :only => [:edit, :update], :conditions => { :subdomain => /.+/ }
  map.resources :items, :collection => { :expirings => :get }, :only => [:expirings], :conditions => { :subdomain => /.+/ }
  map.resources :firemen, :conditions => { :subdomain => /.+/  }
  map.resources :messages, :member => { :mark_as_read => :post }, :only => [:index, :show], :conditions => { :subdomain => /.+/  }
  map.resources :newsletters, :member => { :activate => :get}, :only => [:new, :create, :activate], :conditions => { :subdomain => 'www' }
  map.resources :password_resets, :only => [:new, :create, :edit, :update], :conditions => { :subdomain => /.+/  }
  map.profile      '/profile', :controller => 'profiles', :action => 'edit', :conditions => { :subdomain => /.+/ }
  map.update_profile '/profile/update', :controller => 'profiles', :action => 'update', :conditions => { :subdomain => /.+/ }
  map.resources :interventions, :collection => {:stats => :get }, :conditions => { :subdomain => /.+/  }
  map.resources :stations, :collection => { :check => :get }, :only => [:new, :create, :check], :conditions => { :subdomain => 'www' }
  map.resources :uniforms, :collection => { :reset => :post }, :conditions => { :subdomain => /.+/  }
  map.resources :users, :except => [:edit, :update],:conditions => { :subdomain => /.+/  }
  map.resources :vehicles, :conditions => { :subdomain => /.+/  }


  map.home         '/home', :controller => 'pages', :action => 'home', :conditions => { :subdomain => 'www' }
  map.bye          '/bye', :controller => 'pages', :action => 'bye', :conditions => { :subdomain => 'www' }
  map.authenticate '/login/authenticate', :controller => 'user_sessions', :action => 'create', :conditions => { :subdomain => /.+/ }
  map.login        '/login', :controller => 'user_sessions', :action => 'new', :conditions => { :subdomain => /.+/ }
  map.logout       '/logout', :controller => 'user_sessions', :action => 'destroy', :conditions => { :subdomain => /.+/ }
  map.signup       '/signup', :controller => 'stations', :action => 'new', :conditions => { :subdomain => 'www' }

  map.root_front   '/', :controller => 'pages',  :action => 'home', :conditions => { :subdomain => 'www' }
  map.root_back    '/', :controller => 'dashboard', :action => 'index', :conditions => { :subdomain => /.+/  }

  map.error_404    '*url', :controller => 'dashboard', :action => 'index'
end
