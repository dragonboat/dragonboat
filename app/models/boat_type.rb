class BoatType < ActiveRecord::Base
  IS_ACTIVE = [["Yes", "true"],  ["No", "false"]]
  has_many :teams #!, :dependent=>:destroy
  
  scope_out :active,
            :conditions => "is_active=1",
            :order => "name"
          
  validates_presence_of :name
  validates_numericality_of :price_in_cents
end
