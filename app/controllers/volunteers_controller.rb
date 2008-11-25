class VolunteersController < ApplicationController
  layout "application"
  before_filter :set_statuses

  def new
    @volunteer = Volunteer.new
  end
  
  def create
    @volunteer = Volunteer.new(params[:volunteer])
    @volunteer.status_id = Status[:applied].id
    @volunteer.person.attributes = (params[:person])
    @volunteer.person.validation_mode = :volunteer
    
    if params[:options]
      options = params[:options] 
      #options['times_available']
      times_available = options[:times_available] if  options[:times_available]
      pre_festival_times = options[:pre_festival_times] if  options[:pre_festival_times]
      if times_available
        times_available.each do |t|
          @volunteer.options.build({:option_type=>"times_available", :option=>t})
        end
      end
      
      if pre_festival_times
        pre_festival_times.each do |t|
          #params["#{t}"] 
          now = Time.now
          from = Time.local( now.year, now.month, now.day, params["#{t}"]["from_hour"].to_i)
          to = Time.local( now.year, now.month, now.day, params["#{t}"]["to_hour"].to_i)
          @volunteer.options.build({:option_type=>"pre_festival_times", :option=>t, :from=>from, :to => to})
        end
      end
    end
    #@volunteer.options
    if @volunteer.valid? && @volunteer.save && @volunteer.person.save
      redirect_to :action => :thank_you, :id=>@volunteer.id
    else
      fetch_options
      render :action => 'new'
    end
  end
  
  def thank_you
    @volunteer = Volunteer.find(params[:id])
  end
  
 
  
  private
  def set_statuses
    @statuses = Status.find_volunteer(:all)
  end
  
  def fetch_options
    @options = @volunteer.options #.find_by_type('times_available')
    
  end
end
