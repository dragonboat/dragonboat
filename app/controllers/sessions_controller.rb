# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  #include AuthenticatedSystem
  # render new.rhtml
  def confirm
    if request.post? && current_user && current_user.member
      redirect_to team_index_path(current_user.member.team.name.to_slug)
      return
    end
    flash[:notice] = "Confirmation Code is not valid"  if request.post?
  end
  
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(admin_index_url)
      flash[:notice] = "Logged in successfully"
    else
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
  
  def forgot
    if request.post?      
      user = User.find(:first, :include=>[:person], :conditions=>["persons.email=? AND login=?", params[:email], params[:login]])
      if user
        new_password = user.password_reset!
        if new_password
          UserNotifier.deliver_password_changed(user, new_password) 
          flash[:notice] = "Your new password has been emailed to " + params[:email]
         else
          flash[:notice] = "Password can't be send."
         end
      else
        #flash.delete(:info)
        #flash[:warning] = "No user found with login #{params[:login]} and email address " + params[:email]
        flash[:notice] = "No user found with login #{params[:login]} and email address " + params[:email]
      end
    end
  end
end
