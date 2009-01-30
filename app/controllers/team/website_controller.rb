class Team::WebsiteController < Member::WebsiteController 
 before_filter :is_member?, :fetch_team
 layout 'member'
 
 def index
   redirect_to team_member_confirm_url if @member.is_unconfirmed?
   
   @captain = @team.captain.person
   @current_practices = @team.practices.find(:all, :order=>"created_at")
   @tents = @team.tents
   @paddlers = @team.members.count
   @paddlers_accessibled = @team.members.count_accessibled_paddlers
   @paddlers_declined = @team.members.count_declined_paddlers
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
