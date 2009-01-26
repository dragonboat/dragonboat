class EventsController < ApplicationController
  include EventsHelper
  def index
  end
  
  def update_calendar
    events
    render :update do |page|
      page.replace_html :calendar, :partial => 'events/month', :locals=>{:year=> @year, :month=> @month}      
    end 
  end
  
  def show  
    @event = Event.find(params[:id])
  end
  
 
end
