class TentPositionsController < ApplicationController
  def index
    @tent_positions = TentPosition.find(:all, :order => "number")
  end  
end
