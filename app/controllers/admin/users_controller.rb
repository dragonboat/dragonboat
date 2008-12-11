class Admin::UsersController < Admin::WebsiteController
  # GET /users
  # GET /users.xml
  def index
    conditions = user_search
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
                                :include => [:person],
                                :conditions => conditions,
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
  
  def login_as
    @user = User.find(params[:id])
    session[:user_id] = @user.id if @user
    redirect_back_or_default(member_index_url)
  end
  
  private
  def user_search
    session[:user_search_query] = params[:q] if params[:q]
    session[:user_search_query] = nil if params[:clear]
    conditions = nil
    if session[:user_search_query]
      @query = session[:user_search_query]
      conditions = ["login LIKE :query OR persons.email LIKE :query OR persons.first_name LIKE :query OR persons.last_name LIKE :query OR CONCAT(persons.first_name,' ',persons.last_name) LIKE :query",
                    {:query => "%#{@query}%"}]
    end
    conditions
  end
end
