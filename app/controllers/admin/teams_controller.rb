class Admin::TeamsController < Admin::WebsiteController
  require 'fastercsv'
  def index
    conditions = team_search
    order = case params[:sort]
      when 'name'                   then 'teams.name'
      when 'name_reverse'           then 'teams.name DESC'
      when 'captain'                then 'cp.first_name, cp.last_name'
      when 'captain_reverse'        then 'cp.first_name DESC, cp.last_name DESC'
      when 'created_at'             then 'teams.created_at'
      when 'created_at_reverse'     then 'teams.created_at DESC'
      when 'status'             then 'statuses.name'
      when 'status_reverse'     then 'statuses.name DESC'
      when 'members_count'             then '(SELECT COUNT(*) FROM members m WHERE m.team_id=teams.id)'
      when 'members_count_reverse'     then '(SELECT COUNT(*) FROM members m WHERE m.team_id=teams.id) DESC'
      when 'complete_members_count'          then "( SELECT COUNT(*) FROM members m WHERE m.team_id=teams.id AND m.invitation_status_id=#{Status.find_invitation_by_name('confirmed').id} AND m.waiver_status_id=#{Status.find_waiver_by_name('accept').id})"
      when 'complete_members_count_reverse'  then "( SELECT COUNT(*) FROM members m WHERE m.team_id=teams.id AND m.invitation_status_id=#{Status.find_invitation_by_name('confirmed').id} AND m.waiver_status_id=#{Status.find_waiver_by_name('accept').id} ) DESC"  
      else 'teams.created_at DESC'
    end
    
    @teams = Team.paginate(:page => params[:page], 
                                :include => [:members, :users, :status],
                                :joins => "LEFT JOIN users as captain ON captain.id = teams.captain_id
                                          LEFT JOIN persons cp ON cp.id=captain.person_id",
                                :per_page =>APP_CONFIG["admin_per_page"],
                                :conditions => conditions,
                                :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end
  
  def show
    @team = Team.find(params[:id])
  end
  
  def edit
    @team = Team.find(params[:id])
  end
  
  def update
    @team = Team.find(params[:id])
    @team.attributes = (params[:team])
    if params[:image] && !params[:image].blank?
      @image = Image.new(params[:image])
      @image.user = User.find(current_user)
      @team.image = @image if @image.valid?
    end
    respond_to do |format|
      if  @team.save
        flash[:notice] = 'TEam was successfully updated.'
        format.html { redirect_to admin_teams_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end
      
  def destroy
    @team = Team.find(params[:id])
    flash[:notice] = "The Team with all associated members was successfully deleted" if @team.destroy

    respond_to do |format|
      format.html { redirect_to(admin_teams_url) }
      format.xml  { head :ok }
    end
  end
  
  #Alphabetical View
  def alphabetical_to_csv
    @teams = Team.find(:all, :include => [:members, :users, :status], :order => "teams.name")
    csv_str = FasterCSV.generate do |csv|
      csv << ["Name", "Captain", "E-mail", "Created at", "Members", "Complete Members", "Status"]   
      @teams.each do |team|
        captain = team.captain 
        active = team.members.find_active(:all).size
        csv << [team.name, captain.person.name,  captain.email, team.created_at.strftime("%d/%m/%Y"), team.members.size, active, team.status_human_name]
      end
    end
    send_data csv_str, :type => 'text/csv', :disposition => "attachment;filename=alphabetical_teams_report.csv"
  end
  
  #Chronological View
  def chronological_to_csv
    @teams = Team.find(:all, :include => [:members, :users, :status], :order => "teams.created_at DESC")
    csv_str = FasterCSV.generate do |csv|
      csv << ["Created at", "Name", "Captain", "E-mail", "Members", "Complete Members", "Status"]   
      @teams.each do |team|
        captain = team.captain 
        active = team.members.find_active(:all).size
        csv << [team.created_at.strftime("%d/%m/%Y"), team.name, captain.person.name,  captain.email,team.members.size, active, team.status_human_name]
      end
    end
    send_data csv_str, :type => 'text/csv', :disposition => "attachment;filename=chronological_teams_report.csv"
  end
  
  private
  def team_search
    session[:team_search_query] = params[:q] if params[:q]
    session[:team_search_query] = nil if params[:clear]
    conditions = nil
    if session[:team_search_query]
      @query = session[:team_search_query]
      conditions = ["teams.id LIKE :query OR teams.name LIKE :query OR cp.first_name LIKE :query OR cp.last_name LIKE :query OR CONCAT(cp.first_name,' ',cp.last_name) LIKE :query",
                    {:query => "%#{@query}%"}]
    end
    conditions
  end

end
