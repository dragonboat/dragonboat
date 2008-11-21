class Tent < ActiveRecord::Base
  belongs_to :team
  validates_associated :team
  has_one  :extras_order, :as => :extras, :class_name => "ExtrasOrder"
  
  def price
    APP_CONFIG['tent_price']
  end
end
