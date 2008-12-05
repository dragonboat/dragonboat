class Member::TentsController < Member::WebsiteController
  before_filter :has_boat?
  before_filter :fetch_team
  def index
    @tents = @team.tents
  end
  
  def show
    @tent = @team.tents.find(params[:id])
  end
  
  def update
    @tent = @team.tents.find(params[:id]) 
    @tent.update_attribute(:location, params[:tent][:location])
    
    render :update do |page|
      page.replace_html "tent_location_#{@tent.id}", :partial => "tent_location", :locals => { :tent => @tent, :index=>params[:index] }
    end
  end
end
