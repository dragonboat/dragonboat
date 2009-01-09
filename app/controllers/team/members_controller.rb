class Team::MembersController < Team::WebsiteController
  before_filter :is_confirmed_member?, :except => [:confirm]
  def index
    @members = @team.members.paginate_accessible(:all,
                   :page => params[:page], 
                   :per_page =>APP_CONFIG["admin_per_page"],
                   :order => "created_at desc")
    @members_count = @team.members.find_accessible(:all).size
  end
  
  def confirm
    redirect_to team_edit_user_url(@team.name.to_slug) if !@member.is_unconfirmed?
    if request.post?
      @member.attributes = (params[:member])
      @member.validation_mode = :waiver_form   
      @member.ip = request.remote_ip
      @person =  @member.user.person
      @person.attributes = (params[:person]) if params[:person]
      @person.validation_mode = :sign_waiver
      @member.waiver_sign_at = Time.now()
      if @person.valid? && @member.valid? &&  @person.save && @member.save
        if @member.is_unconfirmed?
          redirect_to logout_url 
        else
          flash[:notice] = "Thank you for joining the team and signing your waiver!"
          redirect_to team_edit_user_url(@team.name.to_slug)
        end
      end
    end
    
  end
end
