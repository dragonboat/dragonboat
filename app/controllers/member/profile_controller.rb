class Member::ProfileController < Member::WebsiteController 
before_filter :is_not_member?
before_filter :set_user, :only=>[:index,:edit,:show]
before_filter :fetch_team

def index
  render :action=>:edit  
end

def edit 
end


def update
  @user = current_user
  @user.person.attributes = (params[:person])
  respond_to do |format|
      if @user.update_attributes(params[:user]) && @user.person.save
        if params[:user]&&params[:user][:password].length > 0
          flash[:notice] = 'Your password has been changed.'
          UserNotifier.deliver_password_changed(@user, params[:user][:password])   
        else
          flash[:notice] = 'Changes to your profile have been saved.'
        end
        format.html { redirect_to @team && @team.active? ? member_edit_team_profile_url(@team) : member_edit_profile_url}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
  end
end

private
def set_user
  @user = current_user
  @person = @user.person
  @person.email = @user.email unless  @person.email
end

 def fetch_team
   begin
     @team = current_user.teams.find(params[:team_id])
     @teams = current_user.teams.find_active(:all, :order=>"created_at DESC")
   rescue Exception 
     @team = current_user.member.team  if current_user.is_member?
     @team = current_user.teams.find(:first, :order=>"created_at") unless @team
   end
 end
end
