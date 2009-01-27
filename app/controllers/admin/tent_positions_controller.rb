class Admin::TentPositionsController < Admin::WebsiteController
  require 'fastercsv'
  in_place_collection_edit_for :tent_position, :status,  TentPosition::STATUS 
  
  def index
    order = case params[:sort]
      when 'number'             then 'number'
      when 'number_reverse'      then 'number desc'
      when 'status'             then 'status'
      when 'status_reverse'      then 'status desc'     
      else 'tent_positions.number DESC'
    end
    
    @tent_positions = TentPosition.paginate( :page => params[:page],
                              :per_page =>400,
                              :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tent_positions }
    end
  end
  
  def team_tents
    conditions = team_search
    order = case params[:sort]
      when 'name'                   then 'teams.name'
      when 'name_reverse'           then 'teams.name DESC'
      when 'captain'                then 'cp.first_name, cp.last_name'
      when 'captain_reverse'        then 'cp.first_name DESC, cp.last_name DESC'
      when 'created_at'             then 'teams.created_at'
      when 'created_at_reverse'     then 'teams.created_at DESC'
      else 'teams.created_at DESC'
    end
    @teams = Team.paginate_active(:all, :order=>order,  
                                :conditions => conditions,
                                :page => params[:page], 
                                :per_page => 200,
                                :include => [:members, :users, :status],
                                :joins => "LEFT JOIN users as captain ON captain.id = teams.captain_id
                                          LEFT JOIN persons cp ON cp.id=captain.person_id")
  end
  
  def change_tents_number
    @team = Team.find(params[:id])
    @main_tents = @team.tents.find_main(:all, :order=>"created_at DESC")
    @other_tents = @team.tents.find_additional(:all, :order=>"created_at DESC")
    
    
    if request.post? && params[:main_total]
      total = params[:main_total].to_i
      if total > 2
        flash[:notice] = "Can update main tents number. It should be <= 2."
      else
        flash[:notice] = "The Main Tents Number was was successfully updated."
      end
      if total > @main_tents.size && total <= 2
        (total-@main_tents.size).times {@team.tents.create(:t_type=>"main")}
      elsif  total < @main_tents.size   
        (@main_tents.size - total).times do |i|
          tent = @main_tents.last
          tent_position = TentPosition.find_by_number(tent.location.to_i)    
          tent.unreserved(tent_position) if tent_position
          tent.destroy
          @main_tents.pop
        end
      end
    end

    if request.post? && params[:other_total]
      flash[:notice]+= " The Other Tents Number was was successfully updated"
      total =  params[:other_total].to_i
      
       if total > @other_tents.size
        (total-@other_tents.size).times {@team.tents.create(:t_type=>"additional")}
      elsif  total < @other_tents.size   
        (@other_tents.size - total).times do |i|
          tent = @other_tents.last  
          tent.destroy
          @other_tents.pop
        end
       end
    end
    
  end
  
  def manage_additional_tents
    @team = Team.find(params[:id])
    @main_tents = @team.tents.find_main(:all, :order=>"created_at")
    @other_tents = @team.tents.find_additional(:all, :order=>"created_at")   
    if request.post? && params[:main_tents]
      @main_tents.each {|t| t.update_attribute(:location,"")}
      i = 0
      params[:main_tents].each_key do |location|
        @main_tents[i].update_attribute(:location,location)
        i+=1
      end
    end
    
    if request.post? && params[:additional]
      @other_tents.each {|t| t.update_attribute(:location,"")}
      i = 0
      params[:additional].each_key do |location|
        @other_tents[i].update_attribute(:location,location)
        i+=1
      end
    end
   
    @tent_positions = TentPosition.find( :all,:order => "number")
    @tents = Tent.find_not_empty_all(:all)   
  end
  
  def edit
    @tent_position = TentPosition.find(params[:id]) 
  end
  
  def update
    @tent_position = TentPosition.find(params[:id]) 
    @tent_position.attributes=(params[:tent_position])    
    respond_to do |format|
      if  @tent_position.save
        flash[:notice] = 'Tent Position was successfully updated.'
        format.html { redirect_to admin_tent_positions_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tent_position.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @tent_position = TentPosition.find(params[:id]) 
    @tent_position.destroy
    flash[:notice] = 'Tent Position was successfully deleted.'
    respond_to do |format|
      format.html { redirect_to(admin_tent_positions_url) }
      format.xml  { head :ok }
    end
  end
  
  def tent_positions_to_csv
  #Position Number, Team Name A, Team Name B, Team Name C -- for each of the tent positions. 
  #Additional Columns (taken from Team A): Captain Name, Captain Email, Captain Phone
     @tent_positions = TentPosition.find(:all,:order => "number")
     @tents = Tent.find_not_empty_all(:all)
     csv_str = FasterCSV.generate do |csv|
      csv << ["Position Number", "Team Name A", "Team Name B", "Team Name C", "Team Name F", "Team Name G", "Captain Name", "Captain Email", "Captain Phone"]   
      @tent_positions.each do |position|
        row = []
        reserved = @tents.map(&:location).include?(position.number.to_s)
        @team = Tent.find_by_location(position.number.to_s).team if reserved
        row << position.number
        row << (@team ? CGI.unescapeHTML(@team.name) : nil)
        %w(B C D F G).each do |p|
           location = "#{position.number.to_s}#{p}"
           reserved = @tents.map(&:location).include?(location)
           team = Tent.find_by_location(location).team if reserved
           row << (team ? CGI.unescapeHTML(team.name) : nil)
        end
        row << [@team.captain.person.name,@team.captain.email, @team.captain.person.phone ] if @team
        row << [nil,nil,nil] unless @team
        csv << row
      end
    end
    send_data csv_str, :type => 'text/csv', :disposition => "attachment;filename=tent_positions_to_csv.csv"
  end
  
   private
  def team_search
    session[:team_tents_search_query] = params[:q] if params[:q]
    session[:team_tents_search_query] = nil if params[:clear]
    conditions = nil
  
    if session[:team_tents_search_query]
      @query = session[:team_tents_search_query]
      conditions = ["(teams.id LIKE :query OR teams.name LIKE :query OR cp.first_name LIKE :query OR cp.last_name LIKE :query OR CONCAT(cp.first_name,' ',cp.last_name) LIKE :query)",
                    {:query => "%#{@query}%"}]
    end
    conditions
  end
end
