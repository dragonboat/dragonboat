class Team::ProfileController < Team::WebsiteController
  before_filter :is_confirmed_member?

  def index
   render :action=>:edit
  end
  def edit
  end
  def update
    @person.attributes = (params[:person])
    @person.validation_mode = :member 
    respond_to do |format|
        if  @person.valid? && @person.save
          flash[:notice] = 'Profile Settings was successfully updated.'
          format.html { redirect_to team_edit_profile_url(@team.name.to_slug) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
    end
  end

end
