class Member::MembersController < Member::WebsiteController 
  before_filter :has_boat?
  before_filter :fetch_team
  before_filter :set_types 
  include ApplicationHelper
  def index
    list
    new
  end
  
  def list
    order = case params[:sort]
      when 'name'             then 'persons.first_name, persons.last_name'
      when 'name_reverse'      then 'persons.first_name desc, persons.last_name desc'
      when 'email'             then 'persons.email'
      when 'email_reverse'      then 'persons.email desc'
      when 'type'             then 'member_types.name'
      when 'type_reverse'      then 'member_types.name desc'
      when  'gender'          then 'persons.gender'
      when  'gender_reverse'   then 'persons.gender desc'  
      when 'invitation'             then 'statuses.name'
      when 'invitation_reverse'      then 'statuses.name desc'
      when 'waiver_status'             then 'statuses.name'
      when 'waiver_status_reverse'      then 'statuses.name desc'  
      when 'created_at'   then 'members.created_at'
      when 'created_at_reverse'   then 'members.created_at DESC'
      else 'members.created_at DESC'
    end
    @members = @team.members.paginate(:page => params[:page], 
                   :include =>[:type, :invitation_status,:waiver_status],
                   :joins => "LEFT JOIN users ON users.id = members.user_id LEFT JOIN persons ON persons.id = users.person_id",
                   :per_page =>APP_CONFIG["admin_per_page"],
                   :order => order)
    @members_count = @team.members.count(:all,
                   :include =>[:type, :invitation_status,:waiver_status],
                   :joins => "LEFT JOIN users ON users.id = members.user_id LEFT JOIN persons ON persons.id = users.person_id"
                 )
  end
  
  def new
    @member = @team.members.build
    @member.invitation_status_id = invitation_status_id_by_name('unconfirmed')
    @member.type_id = MemberType.find_by_name('paddler')
    @user = User.new
    @person = @user.person
  end
  
  def create
    @member = @team.members.build(params[:member])
    @user = User.new(params[:user])
    @person = @user.person
    @person.attributes = (params[:person])
    @person.validation_mode = :member 
    if @person.valid?
      @user.generate_account(@team.name)
    end
    @member.user = @user
    
    if  @person.valid?  && !@user.valid?
      raise "A user account is not valid: #{@user.errors.full_messages.to_s}"
    end
    
    if @person.valid? && @user.valid? && @member.valid? && @person.save! && @user.save! && @member.save! 
       list
       new
       render :update do |page|
          page.replace_html :member_list,  :partial => 'member_list'
          page.replace_html :inline_form,  :partial => 'inline_form'
       end
     else
       render :update do |page|
          page.replace_html :inline_form,  :partial => 'inline_form'
       end
     end
  end
  
  def edit
    @member = @team.members.find(params[:id])
    @user = @member.user
    @person = @user.person
  end
  
  def update
    @member = @team.members.find(params[:id])
    @user = @member.user
    @person = @user.person
    @person.attributes = (params[:person])
    @person.validation_mode = :member 
    @member.attributes=(params[:member])
    respond_to do |format|    
    if  @person.valid? && @user.valid? && @member.valid? && @person.save! && @user.save! && @member.save!
        flash[:notice] = 'Member was successfully updated.'
        format.html { redirect_to member_team_members_url(@team) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @member = @team.members.find(params[:id])
    @user = @member.user
    @person = @user.person
  end

 def confirm
    @member = @team.members.find(params[:id])
    @person =  @member.user.person
    redirect_to member_team_members_url(@team) if !@member.is_unconfirmed?
    if request.post?
      @member.attributes = (params[:member])
      @member.validation_mode = :waiver_form   
      @member.ip = request.remote_ip  
      @person.attributes = (params[:person]) if params[:person]
      unless @member.is_decline?
        @person.validation_mode = :sign_waiver
      end
      @member.waiver_sign_at = Time.now()
      if @person.valid? && @member.valid? &&  @person.save && @member.save     
        flash[:notice] = "Enter Waiver Info was successfully updated."
        redirect_to member_team_members_url(@team)
      end
    end
  end
  
  def access
    @member = @team.members.find(params[:id])
    @user = @member.user
    @person = @user.person
  end
  
  def delete
    @member = @team.members.find(params[:id])
    if @member.destroy
      flash[:notice] = "The member was successfully deleted" 
    end
    redirect_to member_team_members_url(@team)
  end
  
  def resend_invitation
    @member = @team.members.find(params[:id])
    begin
      MemberNotifier.send("deliver_unconfirmed", @member)
    rescue Exception 
      flash[:notice] = "Please try again, error occurred while re-sending the invitation #{e}"
      redirect_to member_team_members_url(@team)
    end
    flash[:notice] = "The invitation e-mail  was successfully re-sent to the member < #{@member.user.email} >"
    redirect_to member_team_members_url(@team)
  end
  
  def send_email_to_team
    result = ""
    subject = params[:subject].chomp if params[:subject]
    body = params[:body].chomp if params[:body]
    if subject && !subject.empty? && body && !body.empty?
      @team.members.each do |member|
        MemberEmail.deliver_team_notifier(member,subject,body)
      end
      result = "The team email was successfully sent to your team members"
    else
      result = "Sorry, we could not send your message. You should fill in required fields."
    end
    render :text=>result, :layout => false
  end
  
  
  private
  def set_types
    @types = MemberType.find(:all)
    @statuses = Status.find_invitation(:all, :order => "name")
  end
end
