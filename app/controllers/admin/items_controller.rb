class Admin::ItemsController < Admin::WebsiteController
 in_place_collection_edit_for :extras, :is_available,  Extras::IS_AVAILABLE
  def index
    @extras_items = Extras.paginate(:all,
                                 :page => params[:page],
                                 :per_page =>APP_CONFIG["admin_per_page"],
                                 :order => 'name')
  end
  
  def new
    @extras_item =  Extras.new
  end
  
  def create
    @extras_item =  Extras.new(params[:extras_item])
    if  @extras_item.save
       respond_to do |format|
       flash[:notice] = 'Type was successfully created.'
       format.html { redirect_to admin_items_path }
       end
     else
       render :action=>:new
     end
  end
  
  def edit
    @extras_item = Extras.find(params[:id]) 
  end
  
  def update
    @extras_item = Extras.find(params[:id]) 
    @extras_item.attributes=(params[:extras_item])    
    respond_to do |format|
      if @extras_item.save
        flash[:notice] = 'Type was successfully updated.'
        format.html { redirect_to admin_items_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @extras_item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @extras_item = Extras.find(params[:id]) 
    @extras_item.destroy
    respond_to do |format|
      format.html { redirect_to(admin_items_url) }
      format.xml  { head :ok }
    end
  end

end
