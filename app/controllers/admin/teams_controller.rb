class Admin::TeamsController < Admin::WebsiteController
  def index
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
                                :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
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

end
