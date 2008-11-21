class Status < ActiveRecord::Base
  acts_as_enumerated
  scope_out :invitation,
            :conditions => "status_type='Invitation'",
            :order =>"name"
          
  scope_out :waiver,
            :conditions => "status_type='Waiver'",
            :order =>"name"
          
  scope_out :volunteer,
            :conditions => "status_type='Volunteer'",
            :order =>"name"
  scope_out :practice,
            :conditions => "status_type='Practice'",
            :order =>"name"
  scope_out :team,
            :conditions => "status_type='Team'",
            :order =>"name"
end
