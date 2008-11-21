class Status < ActiveRecord::Base
  acts_as_enumerated
  scope_out :invitation,
            :conditions => "type='Invitation'",
            :order =>"name"
          
  scope_out :waiver,
            :conditions => "type='Waiver'",
            :order =>"name"
          
  scope_out :volunteer,
            :conditions => "type='Volunteer'",
            :order =>"name"
  scope_out :practice,
            :conditions => "type='Practice'",
            :order =>"name"
  scope_out :team,
            :conditions => "type='Team'",
            :order =>"name"
end
