class Volunteer < ActiveRecord::Base
  belongs_to :person
  validates_associated :person
  has_enumerated  :status, :class_name => 'Status',:foreign_key => 'status_id'
  
  has_many :options, :class_name => 'VolunteerOptions',:foreign_key => 'volunteer_id', :dependent=>:destroy
  
  belongs_to :status
  def after_initialize
    build_person unless person
  end
  
  def after_destroy
    person.destroy
  end
  
  
end
