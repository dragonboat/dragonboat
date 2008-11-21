class Team::UsersController < Team::WebsiteController

  def index
   render :action=>:show
  end
  
  def update
    @person.attributes = (params[:person])
    @person.validation_mode = :member 
    respond_to do |format|
        if  @person.valid? && @person.save
          flash[:notice] = 'Profile Settings was successfully updated.'
          format.html { redirect_to team_user_url }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        end
    end
  end

end
