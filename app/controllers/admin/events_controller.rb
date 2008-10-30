class Admin::EventsController < Admin::WebsiteController
include TinymceUse 
before_filter :set_view, :get_view
before_filter :init_filter, :set_filter, :store_filter #, :only=>:calendar

def index
  if @view == "list"
    order = case params[:sort]
    when 'name'                then 'name'
      when 'name_reverse'        then 'name desc'
      when 'start_date'            then 'start_date desc'
      when 'start_date_reverse'            then 'start_date'
      else 'start_date desc'
    end
    @events = Event.paginate(:page => params[:page], 
                   :per_page =>APP_CONFIG["admin_per_page"],
                   :order => order)
    render :action=>"list"
  elsif @view == "calendar"
    calendar
    render :action=>"calendar"
  end
end

def new
  @event = Event.new
  mday = params[:mday] if params[:mday]
  mon = params[:mon] if params[:mon]
  year = params[:year] if params[:year]
  @event.start_date = Time.local(year, mon, mday)  if year
end

def create
  @event = Event.new(params[:event])
  if @event.save
    @event.tag_with(params[:tag_list]) 
    respond_to do |format|
      flash[:notice] = 'Event was successfully created.'
      format.html { redirect_to admin_events_path }
    end
  else
    render :action=>:new
  end
end
 
def edit
  @event = Event.find(params[:id])
end

def update
  @event = Event.find(params[:id])
  @event.attributes=(params[:event])    
  @event.tag_with(params[:tag_list])    
  respond_to do |format|
  if @event.save
    flash[:notice] = 'Event was successfully updated.'
    format.html { redirect_to admin_events_url }
    format.xml  { head :ok }
  else
    format.html { render :action => "edit" }
    format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
  end
 end
end

def destroy
  @event = Event.find(params[:id])
  @event.destroy

    respond_to do |format|
      format.html { redirect_to(admin_events_url) }
      format.xml  { head :ok }
    end
end

def calendar
  @start_date = @filter.start_date
  @end_date = @filter.end_date
  @events = Event.find(:all,
      :conditions => @filter.to_conditions,
      :order => "start_date DESC, created_at DESC")
end

private
def set_view
  session[:events_view] = params[:view] if params[:view]
end

def get_view
  @view = session[:events_view] ? session[:events_view] : "list"
end
  
def init_filter
  @filter = session[:events_filter]? session[:events_filter]:EventFilter.new(Date.today.beginning_of_year,(Date.today.next_year.beginning_of_year-1.month))
end

def store_filter
  session[:events_filter] = @filter
end

def set_filter
  return unless params[:filter]
  @filter.start_date = get_local_time(params[:filter], "start_date") 
  @filter.end_date = get_local_time(params[:filter], "end_date")  
end

def get_local_time(params, field)
  Time.local(params["#{field}(1i)"], params["#{field}(2i)"], params["#{field}(3i)"]).to_date
end
end
