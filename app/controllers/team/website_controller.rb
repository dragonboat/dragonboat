class Team::WebsiteController < Member::WebsiteController 
 before_filter :is_member?, :fetch_team
 layout 'team'
 
 def index
   
 end
 
 private
 def fetch_team 
   @member = current_user.member
   @team = @member.team
   @user = @member.user
   @person = @user.person
 end
end
