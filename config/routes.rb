ActionController::Routing::Routes.draw do |map|
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
  #map.home '',  :controller => 'news',:action=>"index"
  
  map.with_options :path_prefix => 'member', :name_prefix => 'member_' do |m|
    m.index   '', :controller => 'member/website',  :action => 'index'
    #m.profile '/profile/:id',    :controller => 'member/users', :action=>"show"
    m.resource   :tent, :controller => 'member/tents'
    
    #m.resources :users, :controller => 'member/users', :collection => { :index => :get, :edit => :get, :update=>[:put,:post],:create=>:post } 
   # m.resources :users, :controller => 'member/users'
    m.resource :profile,    :controller => 'member/profile'
    m.extras_boat  '/boats/:id/extras', :controller => 'member/boats', :action => 'extras'
    m.resources   :boats, :controller => 'member/boats'
    m.boat_checkout '/boats/:team_id/checkouts/:action/:id', :controller => 'member/checkouts'
    m.team_members '/boats/:team_id/members/:action/:id', :controller => 'member/members'
    m.team_practices '/boats/:team_id/practices/:action/:id', :controller => 'member/practices'
    m.team_tents '/boats/:team_id/tents/:action/:id', :controller => 'member/tents'
    m.reply '/support/reply/:id/:answer_id', :controller => 'member/support', :action => 'reply'
    m.tickets_list '/support/list', :controller => 'member/support',  :action => 'index'
  end
  
  map.with_options :path_prefix => 'member/boats/:team_id', :name_prefix => 'member_team_' do |m|
   # m.tickets_list '/support/list', :controller => 'member/support',  :action => 'index'
    m.reply '/support/reply/:id/:answer_id', :controller => 'member/support', :action => 'reply'
    m.tickets_list '/support/list', :controller => 'member/support',  :action => 'index'
  end
  
  map.team_confirm_form "team/confirm", :controller => 'sessions', :action=>"confirm"
   
  map.with_options :path_prefix => 'team/:slug', :name_prefix => 'team_' do |m|
    m.index   '', :controller => 'team/website', :action => 'index'
    m.resource    :profile,    :controller => 'team/profile'
    m.member_confirm   'member/confirm',    :controller => 'team/members', :action=> "confirm"
    m.resources    :members,    :controller => 'team/members'
    m.url_code 'member/confirm/:url_code', :controller => 'team/website', :action => 'index'
  end
  
  map.with_options :path_prefix => 'member/boats/:team_id', :name_prefix => 'member_' do |m|
    m.resource :team_profile,    :controller => 'member/profile'
    m.create_member "/paddlers/:id/create_member",    :controller => 'member/paddlers', :action=>"create_member"
    m.invite_paddler "/paddlers/:id/invite",    :controller => 'member/paddlers', :action=>"invite"
    m.resources   :paddlers,    :controller => 'member/paddlers' 
  end
  
  map.with_options :path_prefix => 'admin/teams/:team_id', :name_prefix => 'admin_' do |m|
    m.list_by_waiver_sign_status_to_csv  'paddlers/list_by_waiver_sign_status_to_csv/:status',    :controller => 'admin/paddlers', :action=>"list_by_waiver_sign_status_to_csv"
    m.list_by_invitation_status 'paddlers/list_by_invitation_status/:status',    :controller => 'admin/paddlers', :action=>"list_by_invitation_status"
    m.list_by_waiver_sign_status 'paddlers/list_by_waiver_sign_status/:status',    :controller => 'admin/paddlers', :action=>"list_by_waiver_sign_status"
    m.access_paddler 'paddlers/:id/access',    :controller => 'admin/paddlers', :action=>"access"
    m.resources     :paddlers,    :controller => 'admin/paddlers'
  end
  
  map.with_options :path_prefix => 'admin', :name_prefix => 'admin_' do |m|
    m.index   '',    :controller => 'admin/website',  :action => 'index'
    m.resources     :support_tickets,    :controller => 'admin/support'
    m.resources     :users,    :controller => 'admin/users'
    m.resources     :news_contents,    :controller => 'admin/news_contents'
    m.resources     :images,    :controller => 'admin/images'
    m.resources     :files,    :controller => 'admin/files'
    m.send_message_volunteer  'volunteers/:id/send_message', :controller => 'admin/volunteers', :action=>'send_message'
    m.send_message_by_type_volunteer  'volunteers/send_message_by_type', :controller => 'admin/volunteers', :action=>'send_message_by_type'
    m.resources     :volunteers,    :controller => 'admin/volunteers'
    m.resources     :events,    :controller => 'admin/events'
    m.resources     :practices,    :controller => 'admin/practices'  
    m.teams_alphabetical 'teams/teams_alphabetical' , :controller => 'admin/teams', :action=>"alphabetical_to_csv"
    m.teams_chronological 'teams/teams_chronological' , :controller => 'admin/teams', :action=>"chronological_to_csv"
    m.resources     :teams,    :controller => 'admin/teams'
    m.resources     :boat_types,    :controller => 'admin/boat_types'
    m.resources     :items,    :controller => 'admin/items'
    m.resources     :orders,    :controller => 'admin/orders'
    m.resources     :tent_positions,    :controller => 'admin/tent_positions'
    m.snippets_index 'snippets', :controller => 'admin/snippets',:action=> 'index'
  end
  
  map.register_user "/register", :controller =>"users", :action=>"new"
  map.register_free_user "/register_for_free", :controller =>"users", :action=>"free"
  map.resources :users
  map.resource :session
  map.create_ticket '/support/new', :controller => 'support', :action=>"new"
  map.resource :support, :controller => 'support'
  map.resources :volunteers
  map.resources :paddlers
  map.reply '/support/reply/:id/:answer_id', :controller => 'support', :action => 'reply'
  
  map.cvv   '/cvv', :controller => 'users',  :action => 'cvv'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.change_password '/change_password/:code', :controller => 'sessions', :action => 'change_password'
  map.forgot '/forgot', :controller => 'sessions', :action => 'forgot'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  # install comatose root lowest priority
  map.comatose_admin
  map.comatose_root 'home-page',  :layout=>'application', :use_cache=>false
  map.comatose_root '', :layout => 'application', :use_cache=>false
  #map.connect '', :controller =>"home"

  #map.connect 'home', :controller=>'comatose', :action=>"show", :id=>'home-page'
 # map.comatose_home_page 'home', :index=>'application', :use_cache=>false

end
