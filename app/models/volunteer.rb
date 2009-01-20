class Volunteer < ActiveRecord::Base
  belongs_to :person
  validates_associated :person
  has_enumerated  :status, :class_name => 'Status',:foreign_key => 'status_id'
  
  has_many :options, :class_name => 'VolunteerOptions',:foreign_key => 'volunteer_id', :dependent=>:destroy
  
  validates_inclusion_of :have_you_volunteered_before, :in => [true, false]

  belongs_to :status
  def after_initialize
    build_person unless person
  end
  
  def after_destroy
    person.destroy if person
  end
  
  # Validates fields
  def validate
    if options.size == 0
      errors.add_to_base("Select at least one available time for the event")
     # errors.add_to_base("Select at least one available time for the Pre-Festival")
    end
    
    if options.size > 0
      times_available = options.map(&:option_type).include?("times_available")
      pre_festival_times = options.map(&:option_type).include?("pre_festival_times")
      errors.add_to_base("Select at least one available time for the event") unless times_available
     # errors.add_to_base("Select at least one available time for the Pre-Festival") unless pre_festival_times
    end
  end
  
  def have_you_volunteered_before_to_human
    have_you_volunteered_before ? "Yes" : "No"
  end
end
