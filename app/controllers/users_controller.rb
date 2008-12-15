class UsersController < ApplicationController
  #before_filter :login_required
  #before_filter :admin_login_required
 # require_role "admin", :if => "login_required"
  layout "application"
  # render new.rhtml
  def new
    @user = User.new
    @person = Person.new
   # session[:register_user] = nil
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.validation_mode  = :member
    @person = @user.person
    @person.validation_mode = :member 
    
    @person.attributes = (params[:person])    
    if @person.valid? && @user.valid? && @person.save && @user.save
      self.current_user = @user
      redirect_back_or_default(member_new_boat_url)
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end 
  end

#  def confirm
#    if session[:register_user]
#      @user = session[:register_user]
#    end
#    if @user&&@user.save
#      self.current_user = @user
#      redirect_back_or_default(member_new_boat_url)
#      flash[:notice] = "Thanks for signing up!"
#    else
#      new
#      render :action => 'new'
#    end 
#  end
  
#  def unconfirm
#    @user = session[:register_user]
#    render :action => 'new' 
#  end
end
