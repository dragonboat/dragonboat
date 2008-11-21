class Member::WebsiteController < ApplicationController
 before_filter :login_required
 layout 'member'
  
 def index 
  # current_user.member.team.name.to_slug
   redirect_to member_boats_path if current_user.is_captain?&&!current_user.has_any_boat?         
   redirect_to team_index_path(current_user.member.team.name.to_slug) if current_user.is_member?     
 end
 
 private
   def access_denied
      respond_to do |format|
        format.html do
          store_location 
          if current_user
            redirect_to member_index_path
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
    current_user.is_captain?&&!current_user.has_any_boat? ? true : access_denied
  end
  
  def is_member?
    current_user.is_member? ? true : access_denied
  end
  
  def is_not_member?
     !current_user.is_member? ? true : access_denied
  end
  
  def fetch_team
    @team = current_user.teams.find(params[:team_id])
  end
end
