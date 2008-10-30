class Member::UsersController < Member::WebsiteController 
before_filter :set_user, :only=>[:index,:edit,:show]

def index
  render :action=>:show
end

def edit 
end

def update
  @user = current_user
  @user.person.attributes = (params[:person])
  respond_to do |format|
      if @user.update_attributes(params[:user]) && @user.person.save
        if params[:user][:password].length > 0
          UserNotifier.deliver_password_changed(@user, params[:user][:password])   
        end
        flash[:notice] = 'Profile Settings was successfully updated.'
        format.html { redirect_to member_user_url }
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

end
