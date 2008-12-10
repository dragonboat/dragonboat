class Member::PracticesController < Member::WebsiteController 
  before_filter :has_boat?
  before_filter :fetch_team
  
  def index
    
  end
end
