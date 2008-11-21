class Team::MembersController < Team::WebsiteController
  def index
    @members = @team.members.paginate_accessible(:all,
                   :page => params[:page], 
                   :per_page =>APP_CONFIG["admin_per_page"],
                   :order => "created_at desc")
    @members_count = @team.members.find_accessible(:all).size
  end


end
