class Member::PaddlersController < Member::WebsiteController 

 def index
    order = case params[:sort]
      when 'name'             then 'first_name, last_name'
      when 'name_reverse'      then 'first_name desc, last_name desc'
      when 'email'             then 'email'
      when 'email_reverse'      then 'email desc'
      when 'created_at'   then 'orphaned_paddlers.created_at'
      when 'created_at_reverse'   then 'orphaned_paddlers.created_at DESC'
      else 'orphaned_paddlers.created_at DESC'
    end
    @paddlers = OrphanedPaddler.paginate(:page => params[:page], :include=>[:person],
                                :per_page =>APP_CONFIG["admin_per_page"],
                                :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @paddlers}
    end
 end

 def show
   @paddler = OrphanedPaddler.find(params[:id]) 
 end
end
