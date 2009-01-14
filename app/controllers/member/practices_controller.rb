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
    #@practices_by_date = Practice.cou(:all, grou:order => "created_at DESC"
    @current_practices = @team.practices.find(:all, :order=>"created_at")
  end
  
  def show
    mday = params[:mday].to_i if params[:mday]
    mon = params[:mon].to_i if params[:mon]
    year = params[:year].to_i if params[:year]
    @current_day = Date.new(year,mon,mday)
    @practices = Practice.find(:all,
      :conditions => "CAST(created_at AS DATE) = '#{@current_day.to_s(:db)}'",
      :order => "created_at asc")
  end
  
  def edit
    begin
    @practice = Practice.find_available(params[:id])
    @practice.team_id = @team.id
    rescue Exception 
      render :action=> :edit
    end
  end
  
  def undo_reservation
    @practice = @team.practices.find(params[:id])
  end
  
  def undo
    @practice = @team.practices.find(params[:id])
    @practice.undo_team
    flash[:notice] = 'Practice was successfully undone reservation.' if @practice.save
    d = @practice.created_at
    redirect_to member_team_practices_path(:team_id=>@team,:action=>'show', :mday=>d.mday,:mon=>d.mon,:year=>d.year )
  end
  
  def update
    begin

    @practice = Practice.find_available(params[:id])
    practices_per_month = @team.practices.select {|p| p.created_at.strftime("%m-%Y") == @practice.created_at.strftime("%m-%Y")}
   
    @old_practice = practices_per_month.first if practices_per_month.size>0
    @practice.attributes = (params[:practice])
    @practice.team_id = @team.id 
    @current_practice = @practice
    @practice.validation_mode = :team   
    
    if @practice.save
      flash[:notice] = 'Practice was successfully reserved.'
      d = @practice.created_at
      redirect_to member_team_practices_path(:team_id=>@team,:action=>'show', :mday=>d.mday,:mon=>d.mon,:year=>d.year )
    else 
      render :action=> :edit
    end

    rescue Exception 
   #   render :action=> :edit
    end
 end
 
  def reschedule
    begin
    @practice = Practice.find_available(params[:id])
    practices_per_month = @team.practices.select {|p| p.created_at.strftime("%m-%Y") == @practice.created_at.strftime("%m-%Y")}
    if practices_per_month.size>0
      @old_practice = practices_per_month.first 
      @practice.attributes = (params[:practice])
      @practice.team_id = @team.id 
      @practice.launch_driver = @old_practice.launch_driver unless @practice.launch_driver && !@practice.launch_driver.empty?
      @practice.steers_person = @old_practice.steers_person unless @practice.steers_person && !@practice.steers_person.empty?
      @practice.validation_mode = :team
      @old_practice.undo_team 
      flash[:notice] = 'Practice was successfully rescheduled.'  if @old_practice.save && @practice.save
    end
    d = @practice.created_at
    redirect_to member_team_practices_path(:team_id=>@team,:action=>'show', :mday=>d.mday,:mon=>d.mon,:year=>d.year )
    
    rescue Exception 
      render :action=> :edit
    end
  end
  
  private
  def init_filter
   # On admin calendar view, only display July-Oct 2009
   from = Date.new(2009,7).beginning_of_month
   to = Date.new(2009,9).end_of_month
   
   @filter = EventFilter.new(from, to)
  end
end
