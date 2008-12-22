class Extras < ActiveRecord::Base
  IS_AVAILABLE = [["Yes", "true"],  ["No", "false"]]
  has_many :team_extras, :foreign_key => 'extras_id', :class_name=>"TeamExtras",  :dependent=>:destroy
  has_many :extras_order #!, :dependent=>:destroy
  
  scope_out :available,
            :conditions => "is_available=1",
            :order => "created at DESC"
          
  validates_presence_of     :name
  validates_numericality_of :price_in_cents
  
 def self.prices(items)
   s = 0
   items.each {|i| s+=i.price}
   return s
 end
 
 def description
   notice&&!notice.empty? ? "(#{notice})" : ""
 end
end
