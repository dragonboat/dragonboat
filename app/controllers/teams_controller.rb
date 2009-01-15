class TeamsController < ApplicationController
  def index
    # an alphabetical list of teams with their logos, and their team biographies
    @teams_list = Team.find_active(:all, :order => "name")
  end
end
