class ExtrasOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :extras,  :foreign_key => 'extras_id', :class_name => "Extras" #:polymorphic => true
  
  def pay
    read_attribute(:pay).to_f/100
  end
  
  def pay=(price)
    write_attribute(:pay, price*100)
  end
end
