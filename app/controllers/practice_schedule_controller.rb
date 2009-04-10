class PracticeScheduleController < ApplicationController
  #caches_page :index
  #caches_action :index

  def index
    # a chronological list of dates, times, and teams are displayed
    # The field created_at contains the actual Date/Time practice!!
    unless read_fragment({})
      @practices = Practice.find(:all, :order => "created_at")
    end
  end

end
