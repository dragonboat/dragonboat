class Member::PaddlersController < Member::WebsiteController 
 include ApplicationHelper
 before_filter :has_boat?
 before_filter :fetch_team
  
 def index
    order = case params[:sort]
      when 'name'             then 'first_name, last_name'
      when 'name_reverse'      then 'first_name desc, last_name desc'
      when 'email'             then 'email'
      when 'email_reverse'      then 'email desc'
      when 'created_at'   then 'orphaned_paddlers.created_at'
      when 'created_at_reverse'   then 'orphaned_paddlers.created_at DESC'
      else 'orphaned_paddlers.created_at DESC'
    end
    @paddlers = OrphanedPaddler.paginate(:page => params[:page], :include=>[:person],
                                :per_page =>APP_CONFIG["admin_per_page"],
                                :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paddlers}
    end
 end
 
 def invite
   @paddler = OrphanedPaddler.find(params[:id])
   @member = Member.new
   @member.type_id = MemberType[:paddler].id
   @member.team_id = @team.id
   @user = User.new
   @person = @paddler.person
   #@teams = current_user.teams
 end
 
 def create_member
   @paddler = OrphanedPaddler.find(params[:id])
   @member = Member.new(params[:member])
   @member.type_id = MemberType[:paddler].id
  # @team = @member.team
   #@member.invitation_status_id = invitation_status_id_by_name('confirmed')
   @user = User.new(params[:user])
   @person = @paddler.person
   @person.attributes = (params[:person])
   @user.person =  @person
   @person.validation_mode = :member 
   if @person.valid?
     @user.generate_account(@team.name)
   end
   @member.user = @user
   if @person.valid? && @user.valid? && @member.valid? && @person.save! && @user.save! && @member.save!
     #TODO: Drop Paddler from list
     OrphanedPaddler.delete(@paddler.id)
     flash[:notice] = "E-mail with offer to join was successfully sent on #{@person.email}. Paddler was added to team with unconfirmed waiver status."
     redirect_to member_paddlers_path
   else
     #@teams = current_user.teams
     render :action => "invite" 
   end
 end

 def show
   @paddler = OrphanedPaddler.find(params[:id]) 
 end
end