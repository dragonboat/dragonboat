module EventsHelper
  
   def events_calendar
     events
     html = ""
     html << %Q(<div id="calendar">
                #{render(:partial => 'events/month' , :locals=>{:year=> @year, :month=> @month })} 
                </div>)
   end
  
  def init_calendar
    date = get_date ? get_date : Date.today
    @year = date.year
    @month = date.month
    @next_month = date.next_month
    @next_year = (date + 1.year)
    @previous_month = (date.beginning_of_month - 1.day)
    @previous_year = (date - 1.year)
    @current_date = date
  end

  def get_date
    mon = params[:mon].to_i if params[:mon] 
    year = params[:year].to_i if params[:year]
    return unless mon && year
    begin 
      Date.new(year, mon)
    rescue
       nil
    end  
  end
  
  def events
    init_calendar
    @filter = EventFilter.new(@current_date.beginning_of_month, @current_date.end_of_month)
    @events = Event.find(:all,
      :conditions => @filter.to_conditions,
      :order => "start_date DESC, created_at DESC")
  end
end
