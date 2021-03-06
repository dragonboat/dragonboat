class Tent < ActiveRecord::Base
  belongs_to :team
  validates_associated :team
 # has_one  :extras_order, :as => :extras, :class_name => "ExtrasOrder"
  
  scope_out :main,
            :conditions => "t_type='main'"
  scope_out :empty,
            :conditions => "(location IS NULL OR location='') AND t_type='main'"
  scope_out :additional,
            :conditions => "t_type='additional'"
  scope_out :not_empty,
            :conditions => "(location IS NOT NULL AND location<>'') AND t_type='main'"
  scope_out :not_empty_additional,
            :conditions => "(location IS NOT NULL AND location<>'') AND t_type='additional'"
  scope_out :not_empty_all,
            :conditions => "(location IS NOT NULL AND location<>'')"
          
  def reserved(tent_position)
    old_tent_position = TentPosition.find_by_number(self.location.to_i)
    self.location = tent_position.number.to_s
  
    if tent_position.status == "available" && self.save
     tent_position.update_attribute(:status, "reserved") 
     old_tent_position.update_attribute(:status, "available")  if old_tent_position
    end
  end
  
  def unreserved(tent_position)
    self.location = ""
    if self.save
     tent_position.update_attribute(:status, "available") 
    end
  end
  

end
