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
    m.resource   :tent, :controller => 'member/tents'
   
    m.create_member "/paddlers/:id/create_member",    :controller => 'member/paddlers', :action=>"create_member"
    m.invite_paddler "/paddlers/:id/invite",    :controller => 'member/paddlers', :action=>"invite"
    m.resources   :paddlers,    :controller => 'member/paddlers'
    m.resource    :user,    :controller => 'member/users'
    m.extras_boat  '/boats/:id/extras', :controller => 'member/boats', :action => 'extras'
    m.resources   :boats, :controller => 'member/boats'
    m.boat_checkout '/boats/:team_id/checkouts/:action/:id', :controller => 'member/checkouts'
    m.team_members '/boats/:team_id/members/:action/:id', :controller => 'member/members'
    m.team_practices '/boats/:team_id/practices/:action/:id', :controller => 'member/practices'
    m.team_tents '/boats/:team_id/tents/:action/:id', :controller => 'member/tents'
    m.reply '/support/reply/:id/:answer_id', :controller => 'member/support', :action => 'reply'
  end
  
  map.with_options :path_prefix => 'team/:slug', :name_prefix => 'team_' do |m|
    m.index   '', :controller => 'team/website', :action => 'index'
    m.resource    :user,    :controller => 'team/users'
    m.member_confirm   'member/confirm',    :controller => 'team/members', :action=> "confirm"
    m.resources    :members,    :controller => 'team/members'
    m.url_code 'member/confirm/:url_code', :controller => 'team/website', :action => 'index'
  end
  
  map.with_options :path_prefix => 'admin/teams/:team_id', :name_prefix => 'admin_' do |m|
    m.resources     :paddlers,    :controller => 'admin/paddlers'
  end
  
  map.with_options :path_prefix => 'admin', :name_prefix => 'admin_' do |m|
    m.index   '',    :controller => 'admin/website',  :action => 'index'
    m.resources     :support_tickets,    :controller => 'admin/support'
    #m.resources     :paddlers,    :controller => 'admin/paddlers'
    m.resources     :users,    :controller => 'admin/users'
    m.resources     :news_contents,    :controller => 'admin/news_contents'
    m.resources     :images,    :controller => 'admin/images'
    m.resources     :files,    :controller => 'admin/files'
    m.send_message_volunteer  'admin/volunteers/:id/send_message', :controller => 'admin/volunteers', :action=>'send_message'
    m.send_message_by_type_volunteer  'admin/volunteers/send_message_by_type', :controller => 'admin/volunteers', :action=>'send_message_by_type'
    m.resources     :volunteers,    :controller => 'admin/volunteers'
    m.resources     :events,    :controller => 'admin/events'
    m.resources     :practices,    :controller => 'admin/practices'  
    m.teams_alphabetical 'teams/teams_alphabetical' , :controller => 'admin/teams', :action=>"alphabetical_to_csv"
    m.teams_chronological 'teams/teams_chronological' , :controller => 'admin/teams', :action=>"chronological_to_csv"
    m.resources     :teams,    :controller => 'admin/teams'
    m.resources     :boat_types,    :controller => 'admin/boat_types'
    m.resources     :items,    :controller => 'admin/items'
    m.snippets_index '/admin/snippets', :controller => 'admin/snippets',:action=> 'index'
  end
  
  map.register_user "/register", :controller =>"users", :action=>"new"
  map.resources :users
  map.resource :session
  map.resource :support, :controller => 'support'
  map.resources :volunteers
  map.resources :paddlers
  map.reply '/support/reply/:id/:answer_id', :controller => 'support', :action => 'reply'
  
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
end
