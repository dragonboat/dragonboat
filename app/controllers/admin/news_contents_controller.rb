class Admin::NewsContentsController < Admin::WebsiteController
  include TinymceUse
  #in_place_collection_edit_for :news, :is_short, Content.versions
  #in_place_collection_edit_for :news, :is_visible,[["Вкл", "true"],  ["Выкл", "false"]]

  def index
    order = case params[:sort]
    when 'title'                then 'title'
      when 'title_reverse'        then 'title desc'
      when 'is_short'            then 'is_short'
      when 'is_short_reverse'            then 'is_short desc'
      when 'published_at'              then 'published_at'
      when 'published_at_reverse'      then 'published_at desc'
      when 'created_at'              then 'created_at'
      when 'created_at_reverse'      then 'created_by desc'
      when 'created_by'              then 'created_by'
      when 'created_by_reverse'      then 'published_at desc'
      else 'published_at DESC'
    end
    
   session[:news_search_query] = params[:q] if params[:q]
   session[:news_search_query] = nil if params[:clear]
   conditions = nil
   if session[:news_search_query]
     @query = session[:news_search_query]
     conditions = ["title LIKE ? or description LIKE ? ","%#{@query}%", "%#{@query}%"]
   end
   @news_contents = News.paginate(:page => params[:page], 
                   :per_page =>APP_CONFIG["admin_per_page"],
                   :conditions => conditions,
                   :order => order)
    
  end
  
  def new
     @news = current_user.news.new
  end
  
  def create
    @news = News.new(params[:news])
    @news.tag_with(params[:tag_list]) 
    @news.user = current_user
    if @news.save
       respond_to do |format|
       flash[:notice] = 'News was successfully uploaded.'
       format.html { redirect_to admin_news_contents_path }
       end
     else
       render :action=>:new
     end
  end
  
  def edit
    @news = News.find(params[:id]) 
  end
  
  def update
    @news = News.find(params[:id]) 
    @news.attributes=(params[:news])    
    @news.tag_with(params[:tag_list])    
    respond_to do |format|
      if @news.save
        flash[:notice] = 'News was successfully updated.'
        format.html { redirect_to admin_news_contents_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def reload_cover_image
     if params[:cover_image_id].to_i >0
        @image = Image.find(params[:cover_image_id].to_i) 
        filename = @image.thumb.public_filename if  @image
      end
      render :update do |page|
        page.replace_html :current_cover_image, :partial => 'cover_image', :locals => { :cover_image_id=>params[:cover_image_id].to_i, :filename=>filename}
      end

  end
  
  def destroy
    @news = current_user.news.find(params[:id]) 
    @news.destroy

    respond_to do |format|
      format.html { redirect_to(admin_news_contents_url) }
      format.xml  { head :ok }
    end
  end
  
end
