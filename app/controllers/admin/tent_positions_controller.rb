class Admin::TentPositionsController < Admin::WebsiteController
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
end
