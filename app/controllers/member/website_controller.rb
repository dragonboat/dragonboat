class Member::WebsiteController < ApplicationController
 before_filter :login_required, :is_not_admin?
 layout 'member'
  
 def index 
  # current_user.member.team.name.to_slug
   redirect_to member_boats_url if  (current_user.is_captain?&&!current_user.has_any_boat?)
   redirect_to member_new_boat_path if current_user.has_any_boat?         
   redirect_to team_index_path(current_user.member.team.name.to_slug) if current_user.is_member?&&!current_user.is_captain?     
 end
 
 private
   def access_denied
      respond_to do |format|
        format.html do
          store_location 
          if current_user
            redirect_to admin_index_path if current_user.is_admin?
            redirect_to member_index_path unless current_user.is_admin?
          else
            redirect_to new_session_path
          end
        end
        format.any do
          request_http_basic_authentication 'Web Password'
        end
      end
      false
  end
  
  def has_any_boat?
    current_user.has_any_boat? ? true : access_denied
  end
  
  def has_boat?
    unless current_user.is_captain?&&!current_user.has_any_boat? 
      access_denied
      return
    end
    @team = current_user.is_member? ? current_user.member.team : current_user.teams.find(:first)
    true
  end
  
  def is_not_admin?
    !current_user.is_admin? ? true : access_denied
  end
  
  def is_member?
    current_user.is_member?&&!current_user.is_captain? ? true : access_denied
  end
  
  def is_not_member?
     current_user.is_captain? or !current_user.is_member? ? true : access_denied
  end
  
  def fetch_team
    @team = current_user.is_member? ?  current_user.member.team : current_user.teams.find(params[:team_id])
  end
end
