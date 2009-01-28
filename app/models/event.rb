class Event < ActiveRecord::Base
  acts_as_taggable
  validates_presence_of :name, :start_date, :content
  
  def time
    start_date.strftime("%H:%M") if start_date&&start_date.strftime("%H").to_i>0
  end

end
