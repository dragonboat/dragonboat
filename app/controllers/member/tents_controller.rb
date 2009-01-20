class Member::TentsController < Member::WebsiteController
  before_filter :has_boat?
  before_filter :fetch_team, :has_tents?
  def index
    fetch_tent_positions
  end
  
  def show
    #@tent = @team.tent
  end
  
  def update
    @tents = @team.tents.find_main(:all)
    @tent_position = TentPosition.find(params[:id])
   # @tent = @team.tents.find_empty(:first)
    @tent = @team.tents.find_main(:first) unless @tent
    if @tent
      #@tent_position.has_available_next_position?
      
      if  @tent_position.status != "available"
         @tent.errors.add_to_base('Sorry, this tent location is reserved already') unless @tents.map(&:location).include?(@tent_position.number.to_s)
      elsif  @tents.size > 1 && !@tent_position.has_available_next_position?
        unless @tent_position.next_position && @tents.map(&:location).include?(@tent_position.next_position.number.to_s)
          @tent.errors.add_to_base("Sorry, these positions are already reserved") 
        end
      else
       @tent.reserved(@tent_position)
       if  @tents.size > 1
         @tents[1].reserved(@tent_position.next_position)
       end      
      end
    else
     @tent = @team.tents.find_main(:first)
     @tent.errors.add_to_base('You have reserved all available tent positions for your team')
    end
    fetch_tent_positions
    render :update do |page|
      page.replace_html "tent_positions", :partial => "tent_location"
    end
  end
  
  def unreserved
    @tent_position = TentPosition.find(params[:id])
    @tent = @team.tents.find_by_location(@tent_position.number.to_s)
    if @tent
      @tent.unreserved(@tent_position)
    end
    fetch_tent_positions
    render :update do |page|
      page.replace_html "tent_positions", :partial => "tent_location"
    end  
  end
  
  private
  def fetch_tent_positions
    @tents = @team.tents.find_main(:all)
    @tent_postions = TentPosition.find(:all, :order=>"number")
  end
  
  def has_tents?
    @team.tents.size > 0 ? true : access_denied
  end
end
