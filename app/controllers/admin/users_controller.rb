class Admin::UsersController < Admin::WebsiteController
  # GET /users
  # GET /users.xml
  def index
    order = case params[:sort]
      when 'user_login'             then 'login'
      when 'user_logi_reverse'      then 'login desc'
      when 'user_email'             then 'email'
      when 'user_email_reverse'     then 'email desc'
      when 'user_created_at'                then 'users.created_at'
      when '_user_created_at_reverse'        then 'users.created_at desc'
      else 'users.created_at DESC'
    end
    @users = User.paginate(:page => params[:page], 
                                :per_page =>APP_CONFIG["admin_per_page"],
                                :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @roles = [Role.find_by_name(params[:user]['role'])]
    @user.person.attributes = (params[:person])
    @user.roles = @roles
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to admin_users_url }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @user.person.attributes = (params[:person])
    @roles = [Role.find_by_name(params[:user]['role'])]
    @user.roles = @roles
    respond_to do |format|
      if @user.update_attributes(params[:user]) && @user.person.save
        if params[:user][:password].length > 0
          UserNotifier.deliver_password_changed(@user, params[:user][:password])   
        end
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to admin_users_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(admin_users_url) }
      format.xml  { head :ok }
    end
  end
end
