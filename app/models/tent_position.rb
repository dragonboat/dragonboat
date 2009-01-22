class TentPosition < ActiveRecord::Base
  STATUS = [["Available", "available"],  ["Reserved", "reserved"]]
  validates_numericality_of :number
  validates_uniqueness_of :number
  validates_inclusion_of :status, :in=>%w( available reserved )
  
  attr_accessor :team_id 
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
  
   def accept=(checked)
    @accept = checked.to_i
    if checked.to_i == 1
      if self.is_unconfirmed?
        self.waiver_status_id = Status.find_waiver_by_name('decline').id
      else
        self.waiver_status_id = Status.find_waiver_by_name('accept').id
      end
    end
  end
  
  def team_id=(team_id)
    @team_id = team_id.to_i
  end
  
  def team_id
    @tent = Tent.find_by_location(self.number.to_s)
    @team_id = @tent.team_id if @tent
  end
  
  def before_validation
    
    new_team_id = @team_id
    unless new_team_id == team_id
     
      if new_team_id == 0
        @team = Team.find(@team_id)
        @tent = @team.tents.find_by_location(self.number.to_s)  
        @tent.unreserved(self) if @tent
      else
        @team = Team.find(new_team_id)
        @tent = @team.tents.find_main(:first, :order=>"updated_at") 
        if self.status == "reserved"
          old_tent = Tent.find_by_location(self.number.to_s)
          old_tent.update_attribute(:location, "")  if old_tent
          self.update_attribute(:status, "available") 
        end
        @tent.reserved(self)
      end
    end
  end
end
