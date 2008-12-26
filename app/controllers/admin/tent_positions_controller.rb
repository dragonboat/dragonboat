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
                              :per_page =>APP_CONFIG["admin_per_page"],
                              :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tent_positions }
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
