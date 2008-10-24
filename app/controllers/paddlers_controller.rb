class PaddlersController < ApplicationController
  layout "application"
   
  def new
    @paddler = OrphanedPaddler.new
  end
  
  def create
    @paddler = OrphanedPaddler.new(params[:paddler])
    @paddler.person.attributes = (params[:person])
    @paddler.person.validation_mode = :paddler
    if @paddler.valid? && @paddler.save && @paddler.person.save
      redirect_to :action => :thank_you, :id=>@paddler.id
    else
      render :action => 'new'
    end
  end
  
  def thank_you
    @paddler = OrphanedPaddler.find(params[:id])
  end
end
