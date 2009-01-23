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
    if request.post?
      create
    end
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
      flash[:notice] = "The username and/or password you entered were incorrect.<br>Please try to reenter them again correctly.<br><br> Remember passwords are CASE-SENSITIVE. <br>If you continue to have problems, please click on 'Forgot Your Password?' to retrieve your password."
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
      user = User.find(:first, :include=>[:person], :conditions=>["persons.email=? AND login=?", params[:email].strip, params[:login].strip])
      if user
        #new_password = user.password_reset!
        
        UserNotifier.deliver_invite_to_change_password(user) 
        flash[:notice] = "We have emailed instructions for resetting your password to " + params[:email]
        redirect_to login_url
      else
        #flash.delete(:info)
        #flash[:warning] = "No user found with login #{params[:login]} and email address " + params[:email]
        flash[:notice] = "No user found with login #{params[:login]} and email address " + params[:email]
      end
    end
  end
  
  def change_password
    @user = User.find_all_by_code(params[:code].strip)
    unless @user
      flash[:notice] = "This link is incorrect. To receive a good link on your email fill in 'Password Restore' form below"
      redirect_to forgot_url
      return false
    end

    if request.post?&&params[:user][:password].length > 0 
      @user.attributes = (params[:user])
      @user.valid? && @user.save
      flash[:notice] = 'Your password has been changed.'
      UserNotifier.deliver_password_changed(@user, params[:user][:password])  
      redirect_to login_url
    end
  end
end
