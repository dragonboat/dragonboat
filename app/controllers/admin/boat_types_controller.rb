class Admin::BoatTypesController < Admin::WebsiteController
  in_place_collection_edit_for :boat_type, :is_active,  BoatType::IS_ACTIVE
  def index
    @boat_types = BoatType.paginate(:all,
                                 :page => params[:page],
                                 :per_page =>APP_CONFIG["admin_per_page"],
                                 :order => 'name')
  end
  
  def new
    @boat_type =  BoatType.new
  end
  
  def create
    @boat_type =  BoatType.new(params[:boat_type])
    if  @boat_type.save
       respond_to do |format|
       flash[:notice] = 'Type was successfully created.'
       format.html { redirect_to admin_boat_types_path }
       end
     else
       render :action=>:new
     end
  end
  
  def edit
    @boat_type = BoatType.find(params[:id]) 
  end
  
  def update
    @boat_type = BoatType.find(params[:id]) 
    @boat_type.attributes=(params[:boat_type])    
    respond_to do |format|
      if @boat_type.save
        flash[:notice] = 'Type was successfully updated.'
        format.html { redirect_to admin_boat_types_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @boat_type.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @boat_type = BoatType.find(params[:id]) 
    @boat_type.destroy
    respond_to do |format|
      format.html { redirect_to(admin_boat_types_url) }
      format.xml  { head :ok }
    end
  end
end
