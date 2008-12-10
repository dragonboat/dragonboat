class Member::PracticesController < Member::WebsiteController 
  before_filter :has_boat?
  before_filter :fetch_team
  before_filter :init_filter
  
  def index
    calendar
    render :action=>"calendar"
  end
  
  def calendar
    @start_date = @filter.start_date
    @end_date = @filter.end_date
    @practices = Practice.find(:all,
      :order => "created_at DESC")
  end
  
  def show
    mday = params[:mday].to_i if params[:mday]
    mon = params[:mon].to_i if params[:mon]
    year = params[:year].to_i if params[:year]
    @current_day = Date.new(year,mon,mday)
    @practices = Practice.find(:all,
      :conditions => "CAST(created_at AS DATE) = '#{@current_day.to_s(:db)}'",
      :order => "created_at DESC")
  end
  
  def edit
    @practice = Practice.find_available(params[:id])
    @practice.team_id = @team.id
  end
  
  def undo_reservation
    @practice = @team.practices.find(params[:id])
  end
  
  def undo
    @practice = @team.practices.find(params[:id])
    @practice.team_id = nil    
    flash[:notice] = 'Practice was successfully undone reservation.' if @practice.save
    d = @practice.created_at
    redirect_to member_team_practices_path(:team_id=>@team,:action=>'show', :mday=>d.mday,:mon=>d.mon,:year=>d.year )
  end
  
  def update
    @practice = Practice.find_available(params[:id])
    @practice.team_id = @team.id    
  
    if @practice.save
      flash[:notice] = 'Practice was successfully reserved.'
      d = @practice.created_at
      redirect_to member_team_practices_path(:team_id=>@team,:action=>'show', :mday=>d.mday,:mon=>d.mon,:year=>d.year )
    else 
      render :action=> :edit
    end
 end
  
  private
  def init_filter
   # On admin calendar view, only display July-Oct 2009
   from = Date.new(2009,7).beginning_of_month
   to = Date.new(2009,10).end_of_month
   
   @filter = EventFilter.new(from, to)
  end
end
