class Member::TentsController < Member::WebsiteController
  before_filter :has_boat?
  before_filter :fetch_team
  
  def show
    @tent = @team.tent
  end
  
  def update
    @tent = @team.tent 
    @tent.update_attribute(:location, params[:tent][:location])
    
    render :update do |page|
      page.replace_html :tent_location, :partial => 'tent_location', :locals => { :tent => @tent }
    end
  end
end
