class Member::BoatsController < Member::WebsiteController 
 # before_filter :has_any_boat?, :except => [:index, :edit, :update]
 # require_role "captain", :only=>[:index]
  before_filter :has_boat?, :only=>[:index, :edit, :update, :show]
  before_filter :fetch_team, :only=>[:show, :edit, :update, :extras, :add_extras]
  
  before_filter :secure_site, :except => [:index, :edit, :update, :show]
  skip_before_filter :leave_secure_site
 
  def index
   # @team = @teams.first
    @teams = current_user.teams.find_active(:all, :order=>"created_at DESC")
    if @teams.size > 1
      render :action=>:index
    else
      @team = current_user.is_member? ? current_user.member.team : current_user.teams.find(:first)
      redirect_to member_boat_url(@team)
    end
  end
  
  def show
   @person = current_user.person
   @captain = @team.captain.person
   @current_practices = @team.practices.find(:all, :order=>"created_at")
   @tents = @team.tents
   @paddlers = @team.members.count_paddlers
   @paddlers_accessibled = @team.members.count_accessibled_paddlers
   @paddlers_declined = @team.members.count_declined_paddlers
  end
  
  def new
    @team = current_user.has_any_inactive_boat? ?  current_user.inactive_teams.first : Team.new
 #   session[:register_team] = nil
  end
  
  def create
    @team = current_user.has_any_inactive_boat? ? current_user.inactive_teams.first : Team.new
    @team.attributes = (params[:team])
    @team.captain = current_user
    if params[:image] && !params[:image][:uploaded_data].blank?
      @image = Image.new(params[:image])
      @image.user = User.find(current_user)
      @team.image = @image if @image.valid?
    end
    if @team.valid?&&@team.save
  
      redirect_to member_extras_boat_path(@team.id)
    else
      render :action => 'new'
    end
  end
  
  def edit
    #@team = current_user.teams.find(:first)
  end
  
  def update
    #@team = current_user.teams.find(params[:id])
    @team.attributes = (params[:team])
    if params[:image] && !params[:image][:uploaded_data].blank?
      @image = Image.new(params[:image])
      @image.user = User.find(current_user)
      @team.image = @image if @image.valid?
    end
    respond_to do |format|
      if  @team.save
        flash[:notice] = 'Boat Details Setting was successfully updated.'
        format.html { redirect_to member_boat_url(@team) }
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
    @extras = Extras.find_available(:all)
    @team.team_extras.each(&:destroy) if !@team.team_extras.empty?
    @extras.each do |extras| 
      unless extras.name=="Additional Tent"
        @team.team_extras.create(:extras=>extras, :quantity => 1 ) 
      else
        @team.team_extras.create(:extras=>extras, :quantity => 0 ) 
      end
    end
  end
  
  def add_extras 
    @team.team_extras.each(&:destroy) if !@team.team_extras.empty?
    
    if params[:extras]&&params[:quantity]
      #each_pair
      params[:extras].each_key  do |id|
        extras = Extras.find_available(id)
        quantity = params[:quantity][id].to_i
        @team.team_extras.create(:extras=>extras, :quantity => quantity ) if quantity > 0
      end
    end
    redirect_to member_boat_checkout_path(@team)
  end
  
  def total_cost
    render :update do |page|
      total = 0
      if  params[:quantity]
      params[:quantity].each_pair  do |id,quantity|
        extras = Extras.find_available(id)
        total+= extras.price * quantity.to_i
      end
      end
      page.replace_html "total", :partial => 'total_cost', :locals=>{:total=>total }
    end
  end
  
  def update_total_count
    @extras = Extras.find(params[:id])
   # @extras = Extras.find_available(:all)
    quantity = params[:quantity]
    price = @extras.price
    
    render :update do |page|
      page.replace_html "total_count_#{@extras.id}", :partial => 'member/boats/total_count', :locals=>{:price=>price, :quantity => quantity}
    end
  end
  


  private
  def fetch_team
    @team =  current_user.is_member? ?  current_user.member.team : current_user.teams.find(params[:id])
  end
end
