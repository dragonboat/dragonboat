class Admin::MembersController < Admin::WebsiteController
  
  def index
      conditions = member_search
      order = case params[:sort]
      when 'name'             then 'persons.first_name, persons.last_name'
      when 'name_reverse'      then 'persons.first_name desc, persons.last_name desc'
      when 'email'             then 'persons.email'
      when 'email_reverse'      then 'persons.email desc'
      when 'login'             then 'users.login'
      when 'login_reverse'      then 'users.login desc'
      when 'type'             then 'member_types.name'
      when 'type_reverse'      then 'member_types.name desc'
      when 'ip'             then 'members.ip'
      when 'ip_reverse'      then 'members.ip desc'
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
      @members = Member.paginate(:page => params[:page], 
                                  :include =>[:type,:user, :team],
                                  :joins => "LEFT JOIN users ON users.id = members.user_id LEFT JOIN persons ON persons.id = users.person_id LEFT JOIN statuses i_s ON i_s.id = members.invitation_status_id LEFT JOIN statuses w_s ON w_s.id = members.waiver_status_id",
                                  :conditions => conditions,
                                  :order =>"teams.name, #{order}",
                                  :per_page =>200)
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @members }
      end
  end
  
  def show
    @member = Member.find(params[:id]) 
    @person =@member.user.person
  end
  
  def resend_invitation
    @member = Member.find(params[:id]) 
    begin
      MemberNotifier.send("deliver_unconfirmed", @member)
    rescue Exception 
      flash[:notice] = "Please try again, error occurred while re-sending the invitation #{e}"
      redirect_to admin_members_url
    end
    flash[:notice] = "The invitation e-mail  was successfully re-sent to the member < #{@member.user.email} >"
    redirect_to admin_members_url
  end
 
  private
  def member_search
    session[:member_search_query] = params[:q] if params[:q]
    session[:member_search_query] = nil if params[:clear]
    conditions = nil
    if session[:member_search_query]
      @query = session[:member_search_query]
      conditions = ["members.id  LIKE :query OR DATE_FORMAT(members.created_at,'%d.%m.%Y') LIKE :query OR DATE_FORMAT(members.waiver_sign_at,'%d.%m.%Y') LIKE :query  OR i_s.name LIKE :query  OR w_s.name LIKE :query  OR CONCAT(persons.first_name,' ',persons.last_name) LIKE :query OR persons.first_name LIKE :query OR persons.last_name LIKE :query OR persons.email LIKE :query OR users.login LIKE :query",
                    {:query => "%#{@query}%"}]
    end
    conditions
  end
end
