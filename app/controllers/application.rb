# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # AuthenticatedSystem must be included for RoleRequirement, and is provided by installing acts_as_authenticates and running 'script/generate authenticated account user'.
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem

 

  # Pick a unique cookie name to distinguish our session data from others'
#  session :session_key => '_dragonboat_session_id'
  def get_local_time(params, field)
    Time.local(params["#{field}(1i)"], params["#{field}(2i)"], params["#{field}(3i)"]).to_date
  end
  

end
