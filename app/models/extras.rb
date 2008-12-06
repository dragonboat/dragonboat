class Extras < ActiveRecord::Base
  IS_AVAILABLE = [["Yes", "true"],  ["No", "false"]]
  has_one :team_extras, :foreign_key => 'extras_id', :class_name=>"TeamExtras"
  has_many :extras_order #!, :dependent=>:destroy
  
  scope_out :available,
            :conditions => "is_available=1",
            :order => "name"
          
  validates_presence_of     :name
  validates_numericality_of :price
  
 def self.prices(items)
   s = 0
   items.each {|i| s+=i.price}
   return s
 end
 
 def description
   notice&&!notice.empty? ? "(#{notice})" : ""
 end
end
