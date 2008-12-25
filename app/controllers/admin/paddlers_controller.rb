class Admin::PaddlersController < Admin::WebsiteController
  before_filter :fetch_team
  before_filter :set_types, :only=>[:edit, :update]
  require 'fastercsv'
   
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
  
 def show
   @paddler = @team.members.find_paddlers(params[:id]) 
   @person = @paddler.user.person
 end
 
 def edit
    @paddler = @team.members.find_paddlers(params[:id])
    @user = @paddler.user
    @person = @user.person
 end
  
 def update
    @paddler = @team.members.find_paddlers(params[:id])
    @user = @paddler.user
    @person = @user.person
    @person.attributes = (params[:person])
    @person.validation_mode = :member 
    @paddler.attributes=(params[:paddler])
    respond_to do |format|    
    if  @person.valid? && @user.valid? && @paddler.valid? && @person.save! && @user.save! && @paddler.save!
        flash[:notice] = 'Paddler was successfully updated.'
        format.html { redirect_to admin_paddlers_url(@team) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paddler.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def access
    @paddler = @team.members.find_paddlers(params[:id])
    @user = @paddler.user
    @person = @user.person
  end
  
  def list_by_invitation_status
    @status = Status.find(params[:status])
    @status_title = @status.name=='confirmed' ? "accepted invitations" : "not accepted invitations"
    @paddlers = @team.members.find_paddlers(:all, :conditions => ["invitation_status_id=?",params[:status]], :order=>"members.created_at DESC") 
  end
  
  def list_by_waiver_sign_status
    @status = Status.find(params[:status])
    @status_title = @status.name=='accept' ? "signed waivers" : "not signed waivers"
    if @status.name=='accept'
      conditions = ["waiver_status_id=?",params[:status]]
    else
      conditions = ["waiver_status_id<>?",Status.find_waiver_by_name('accept').id]
    end
    @paddlers = @team.members.find_paddlers(:all, :conditions => conditions, :order=>"members.created_at DESC") 
  end
  
  def list_by_waiver_sign_status_to_csv
    list_by_waiver_sign_status
    csv_str = FasterCSV.generate do |csv|
      csv << ["Name", "E-mail", "Gender", "Invitation Status", "Waiver Status", "Created at", "Date of Signature", "IP", "Team"]   
      @paddlers.each do |paddler|
        user = paddler.user
        person = user.person
        csv << [person.name, person.email, person.gender, paddler.invitation_status.name.capitalize, paddler.waiver_status.name.capitalize, paddler.created_at.strftime("%d/%m/%Y"), paddler.date_of_signature, paddler.ip, @team.name ]
      end
    end
    send_data csv_str, :type => 'text/csv', :disposition => "attachment;filename=#{@team.name.to_slug}_paddlers_list_#{@status_title.gsub(" ","_")}_report.csv"
  end
  
  private
  
  def fetch_team
    @team = Team.find(params[:team_id])
  end
  
  def set_types
    @statuses = Status.find_invitation(:all, :order => "name")
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
