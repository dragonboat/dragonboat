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
    if @volunteer.valid? && @volunteer.save && @volunteer.person.save
      redirect_to :action => :thank_you, :id=>@volunteer.id
    else
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
end
