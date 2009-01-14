class TentPosition < ActiveRecord::Base
  STATUS = [["Available", "available"],  ["Reserved", "reserved"]]
  validates_numericality_of :number
  validates_uniqueness_of :number
  validates_inclusion_of :status, :in=>%w( available reserved )
  
  def team_name
    @tent = Tent.find_by_location(self.number.to_s)
    @tent ? @tent.team.name : "" 
  end
  
  def has_available_next_position?
    begin
      @next = TentPosition.find_by_number(self.number.to_i + 1)
      @next &&  @next.status == 'available'
    rescue Exception 
      false
    end
  end
  
  def next_position
    TentPosition.find_by_number(self.number.to_i + 1)
  end
end
