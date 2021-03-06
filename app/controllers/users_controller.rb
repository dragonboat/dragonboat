class UsersController < ApplicationController
  before_filter :secure_site, :only => [:new, :create]
  skip_before_filter :leave_secure_site
  
  layout "application"
  # render new.rhtml
  def new
    redirect_to(member_new_boat_url) if current_user && current_user.teams.size>0
    if request.post?
      create
      return
    end
    @user = User.new
    @person = Person.new
   # session[:register_user] = nil
  end
  
 def free
    session[:free] = "1"
    if current_user && current_user.teams
      redirect_to(member_new_boat_url) 
    else
    if request.post?
      create
      return
    end
      @user = User.new
      @person = Person.new
      render :action =>:new
    end
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
    @person.validation_mode = :order 
    
    @person.attributes = (params[:person])    
    if @person.valid? && @user.valid? && @person.save && @user.save
      self.current_user = @user
      redirect_back_or_default(member_new_boat_url)
      #flash[:notice] = "Thanks for signing up!"
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
