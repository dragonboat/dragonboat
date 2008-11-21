class Admin::PracticesController < Admin::WebsiteController
before_filter :set_statuses, :only=>[:edit, :update, :new, :create]
before_filter :set_view, :get_view
before_filter :init_filter, :set_filter, :store_filter

 def index
  if @view == "list"
    order = case params[:sort]
    when 'name'                then 'name'
      when 'name_reverse'        then 'name desc'
      when 'created_at'            then 'created_at desc'
      when 'created_at_reverse'            then 'created_at'
      else 'created_at desc'
    end
    @practices = Practice.paginate(:page => params[:page], 
                   :per_page =>APP_CONFIG["admin_per_page"],
                   :order => order)
    render :action=>"list"
  elsif @view == "calendar"
    calendar
    render :action=>"calendar"
  end
end

def new
  @practice = Practice.new
  mday = params[:mday] if params[:mday]
  mon = params[:mon] if params[:mon]
  year = params[:year] if params[:year]
  @practice.created_at = Time.local(year, mon, mday)  if year
end

def create
  @practice = Practice.new(params[:practice])
  if @practice.save
    respond_to do |format|
      flash[:notice] = 'Practice was successfully created.'
      format.html { redirect_to admin_practices_path }
    end
  else
    render :action=>:new
  end
end
 
def edit
  @practice = Practice.find(params[:id])
end

def update
  @practice = Practice.find(params[:id])
  ce.attributes=(params[:practice])    
  respond_to do |format|
  if Practice.save
    flash[:notice] = 'Practice was successfully updated.'
    format.html { redirect_to admin_practices_url }
    format.xml  { head :ok }
  else
    format.html { render :action => "edit" }
    format.xml  { render :xml => @practice.errors, :status => :unprocessable_entity }
  end
 end
end

def calendar
  @start_date = @filter.start_date
  @end_date = @filter.end_date
  @practices = Practice.find(:all,
      :conditions => @filter.to_conditions,
      :order => "created_at DESC")
end

private
  def set_statuses
     @statuses = Status.find_practice(:all)
  end
  
  def set_view
    session[:practices_view] = params[:view] if params[:view]
  end

  def get_view
    @view = session[:practices_view] ? session[:practices_view] : "list"
  end

  def init_filter
   # @filter = session[:practices_filter]? session[:practices_filter]:EventFilter.new(Date.today.beginning_of_year,(Date.today.next_year.beginning_of_year-1.month))
   @filter = EventFilter.new(Date.today.beginning_of_year,(Date.today.next_year.beginning_of_year-1.month))
  end

  def store_filter
   # session[:events_filter] = @filter
  end

  def set_filter
  #  return unless params[:filter]
 #   @filter.start_date = get_local_time(params[:filter], "start_date") 
  #  @filter.end_date = get_local_time(params[:filter], "end_date")  
  end
end
