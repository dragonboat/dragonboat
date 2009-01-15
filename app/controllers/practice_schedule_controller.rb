class PracticeScheduleController < ApplicationController

  def index
    # a chronological list of dates, times, and teams are displayed
    @practices = Practice.find(:all, :order => "created_at")
  end

end
