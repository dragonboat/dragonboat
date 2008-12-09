class Team::WebsiteController < Member::WebsiteController 
 before_filter :is_member?, :fetch_team
 layout 'member'
 
 def index
   redirect_to team_member_confirm_url if @member.is_unconfirmed?
 end
 
 private
 def fetch_team 
   @member = current_user.member
   @team = @member.team
   @user = @member.user
   @person = @user.person
 end
 
 def is_confirmed_member?
   !@member.is_unconfirmed? ? true : access_denied
 end
end
