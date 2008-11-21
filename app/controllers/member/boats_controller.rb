class Member::BoatsController < Member::WebsiteController 
  before_filter :has_any_boat?, :except => [:index, :edit, :update]
 # require_role "captain", :only=>[:index]
  before_filter :has_boat?, :only=>[:index, :edit, :update]
  before_filter :fetch_team, :only=>[:extras, :add_extras]
 
  def index
    @team = current_user.teams.find(:first)
  end
  
  def new
    @team = current_user.has_any_unactive_boat? ?  current_user.unactive_teams.first : Team.new
    session[:register_team] = nil
  end
  
  def create
    @team = current_user.has_any_unactive_boat? ? current_user.unactive_teams.first : Team.new
    @team.attributes = (params[:team])
    @team.captain = current_user
    if @team.valid? #&& @user.save
      session[:register_team] = @team
      render :action => 'confirm'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @team = current_user.teams.find(:first)
  end
  
  def update
    @team = current_user.teams.find(params[:id])
    @team.attributes = (params[:team])
    if params[:image] && !params[:image].blank?
      @image = Image.new(params[:image])
      @image.user = User.find(current_user)
      @team.image = @image if @image.valid?
    end
    respond_to do |format|
      if  @team.save
        flash[:notice] = 'Boat Details Setting was successfully updated.'
        format.html { redirect_to member_boats_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
  end
  end
  
  
  def confirm
    if session[:register_team]
      @team = session[:register_team]
    end
    if @team.valid?&&@team.save
      redirect_to member_extras_boat_path(@team.id)
    else
      @team = Team.new unless @team
      render :action => 'new'
    end
  end

  def unconfirm
    @team = session[:register_team] if session[:register_team]
    render :action => 'new' 
  end
  
  def extras
    
  end
  
  def add_extras 
    if params[:extras_tent]
      @team.create_tent if @team.tent.nil?  
    elsif !@team.tent.nil? 
        @team.tent.destroy
    end
    redirect_to member_boat_checkout_path(@team)
  end

  private
  def fetch_team
    @team = current_user.teams.find(params[:id])
  end
end
