ActionController::Routing::Routes.draw do |map|
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.

  map.resources :newsletters, :member => { :activate => :get}, :only => [:new, :create, :activate], :conditions => { :subdomain => 'www' }
  map.resources :password_resets, :only => [:new, :create, :edit, :update], :conditions => { :subdomain => /.+/  }
  map.resources :stations, :only => [:new, :create], :conditions => { :subdomain => 'www' }
  map.resources :vehicles, :conditions => { :subdomain => /.+/  }
  map.resources :firemen, :conditions => { :subdomain => /.+/  }
  map.resources :uniforms, :conditions => { :subdomain => /.+/  }

  map.activate     '/activate/:id', :controller => 'confirmations', :action => 'create', :conditions => { :subdomain => /.+/  }
  map.home         '/home', :controller => 'pages', :action => 'home', :conditions => { :subdomain => 'www' }
  map.authenticate '/login/authenticate', :controller => 'user_sessions', :action => 'create', :conditions => { :subdomain => /.+/ }  
  map.login        '/login', :controller => 'user_sessions', :action => 'new', :conditions => { :subdomain => /.+/ }
  map.logout       '/logout', :controller => 'user_sessions', :action => 'destroy', :conditions => { :subdomain => /.+/ }  
  map.signup       '/signup', :controller => 'stations', :action => 'new', :conditions => { :subdomain => 'www' }

  map.root_front   '/', :controller => 'pages',  :action => 'home', :conditions => { :subdomain => 'www' }
  map.root_back    '/', :controller => 'dashboard', :action => 'index', :conditions => { :subdomain => /.+/  }
  
  map.error_404    '*url', :controller => 'dashboard', :action => 'index'
end
