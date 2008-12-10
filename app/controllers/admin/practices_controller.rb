class Admin::PracticesController < Admin::WebsiteController
before_filter :set_teams, :only=>[:edit, :update, :new, :create]
before_filter :set_view, :get_view
before_filter :init_filter, :set_filter, :store_filter

 def index
  if @view == "list"
    order = case params[:sort]
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
  @practice.attributes=(params[:practice])    
  respond_to do |format|
  if @practice.save
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
      #:conditions => @filter.to_conditions,
      :order => "created_at DESC")
end

def destroy
    @practice = Practice.find(params[:id]) 
    @practice.destroy
    respond_to do |format|
      flash[:notice] = 'Practice was successfully deleted.'
      format.html { redirect_to(admin_practices_url) }
      format.xml  { head :ok }
    end
 end

private
  def set_teams
    @teams = Team.find_active(:all, @teams, :order => "name")
  end
  
  def set_view
    session[:practices_view] = params[:view] if params[:view]
  end

  def get_view
    @view = session[:practices_view] ? session[:practices_view] : "list"
  end

  def init_filter
   # On admin calendar view, only display July-Oct 2009
   from = Date.new(2009,7).beginning_of_month
   to = Date.new(2009,10).end_of_month
   
   @filter = EventFilter.new(from, to)
  end

  def store_filter
   # session[:events_filter] = @filter
  end

  def set_filter
  #  return unless params[:filter]
  #  @filter.start_date = get_local_time(params[:filter], "start_date") 
  #  @filter.end_date = get_local_time(params[:filter], "end_date")  
  end
end
