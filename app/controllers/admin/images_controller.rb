class Admin::ImagesController < Admin::WebsiteController
  
  def index
    session[:image_search_query] = params[:q] if params[:q]
    session[:image_search_query] = nil if params[:clear]
    conditions = nil
    if session[:image_search_query]
      @query = session[:image_search_query]
      conditions = ["filename LIKE :query OR id = :query",
                    {:query => "%#{@query}%"}]
    end
    @images= current_user.images.paginate(:all,:conditions => conditions,
                                 :page => params[:page],
                                 :per_page =>APP_CONFIG["admin_per_page"],
                                 :order => 'created_at DESC')
   end
   
   
   def create
     @image = Image.new(params[:image])
     @image.user = User.find(current_user)
     if @image.save
       respond_to do |format|
       flash[:notice] = 'Image was successfully uploaded.'
       format.html { redirect_to admin_images_path }
       end
     else
        index
        render :action=>:index
     end
  end
  
  def edit
    @image = current_user.images.find(params[:id])
  end
  
  def update
    @image = current_user.images.find(params[:id])
    if @image.update_attributes(params[:image])
    respond_to do |format|
      flash[:notice] = 'Image was successfully updated.'
      format.html { redirect_to admin_image_path(@image) }
    end
    else
      format.html { render :action => "edit" }
    end
  end
  
  def show
    @image = current_user.images.find(params[:id])
  end
  
  def destroy
    @image = current_user.images.find(params[:id])
    @image.destroy
    respond_to do |format|
      format.html { redirect_to admin_images_path }
    end
  end
end
