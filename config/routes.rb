ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource :session
  map.resources :volunteers
  map.resources :paddlers

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.with_options :path_prefix => 'member', :name_prefix => 'member_' do |m|
    m.index   '',    :controller => 'member/website',  :action => 'index'
    m.resources     :paddlers,    :controller => 'member/paddlers'
  end
  map.with_options :path_prefix => 'admin', :name_prefix => 'admin_' do |m|
    m.index   '',    :controller => 'admin/website',  :action => 'index'
    m.resources     :users,    :controller => 'admin/users'
    m.resources     :news_contents,    :controller => 'admin/news_contents'
    m.resources     :images,    :controller => 'admin/images'
    m.resources     :files,    :controller => 'admin/files'
    m.resources     :volunteers,    :controller => 'admin/volunteers'
  end
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.forgot '/forgot', :controller => 'sessions', :action => 'forgot'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  # install comatose root lowest priority
  map.comatose_admin
  map.comatose_root '', :layout => 'application', :use_cache=>false
  map.comatose_help 'new-page-457675', :index=>'about-us/new-page-457675', :layout=>'application'



end
