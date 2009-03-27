class PracticeScheduleController < ApplicationController
  caches_page :index

  def index
    # a chronological list of dates, times, and teams are displayed
    # The field created_at contains the actual Date/Time practice!!
    @practices = Practice.find(:all, :order => "created_at")
  end

end
