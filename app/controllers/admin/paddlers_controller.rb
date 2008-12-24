class Admin::PaddlersController < Admin::WebsiteController
  before_filter :fetch_team
   
  def index
    conditions = search
    order = case params[:sort]
      when 'name'             then 'persons.first_name, persons.last_name'
      when 'name_reverse'      then 'persons.first_name desc, persons.last_name desc'
      when 'email'             then 'persons.email'
      when 'email_reverse'      then 'persons.email desc'
      when 'type'             then 'member_types.name'
      when 'type_reverse'      then 'member_types.name desc'
      when 'invitation'             then 'i_s.name'
      when 'invitation_reverse'      then 'i_s.name desc'
      when 'waiver_status'             then 'w_s.name'
      when 'waiver_status_reverse'      then 'w_s.name desc'  
      when 'created_at'   then 'members.created_at'
      when 'created_at_reverse'   then 'members.created_at DESC'
      when 'date_of_signature'   then 'members.waiver_sign_at'
      when 'date_of_signature_reverse'   then 'members.waiver_sign_at DESC' 
      else 'members.created_at DESC'
    end
    @paddlers = @team.members.paginate_paddlers(:all, 
                   :page => params[:page], 
                   :include =>[:type,:user],
                   :joins => "LEFT JOIN users ON users.id = members.user_id LEFT JOIN persons ON persons.id = users.person_id LEFT JOIN statuses i_s ON i_s.id = members.invitation_status_id LEFT JOIN statuses w_s ON w_s.id = members.waiver_status_id",
                   :per_page =>APP_CONFIG["admin_per_page"],
                   :conditions => conditions,
                   :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paddlers}
    end
  end
  
  private
  
  def fetch_team
    @team = Team.find(params[:team_id])
  end
  
  def search
    session["paddler_search_query_#{@team.id}"] = params[:q] if params[:q]
    session["paddler_search_query_#{@team.id}"] = nil if params[:clear]
    conditions = nil
    if session["paddler_search_query_#{@team.id}"]
      @query = session["paddler_search_query_#{@team.id}"]
      conditions = ["members.id  LIKE :query OR DATE_FORMAT(members.created_at,'%d.%m.%Y') LIKE :query OR DATE_FORMAT(members.waiver_sign_at,'%d.%m.%Y') LIKE :query  OR i_s.name LIKE :query  OR w_s.name LIKE :query  OR CONCAT(persons.first_name,' ',persons.last_name) LIKE :query OR persons.first_name LIKE :query OR persons.last_name LIKE :query OR persons.email LIKE :query OR users.login LIKE :query",
                    {:query => "%#{@query}%"}]
    end
    conditions
  end

end
