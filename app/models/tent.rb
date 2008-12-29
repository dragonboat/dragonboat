class Tent < ActiveRecord::Base
  belongs_to :team
  validates_associated :team
 # has_one  :extras_order, :as => :extras, :class_name => "ExtrasOrder"
  
  scope_out :empty,
            :conditions => "location IS NULL OR location=''"
          
  def reserved(tent_position)
    self.location = tent_position.number.to_s
    tent_position.update_attribute(:status, "reserved") if self.save
  end
end
