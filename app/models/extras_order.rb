class ExtrasOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :extras,  :foreign_key => 'extras_id', :class_name => "Extras" #:polymorphic => true
end
