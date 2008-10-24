class Status < ActiveRecord::Base
  acts_as_enumerated
  scope_out :volunteer,
            :conditions => "type='Volunteer'",
            :order =>"name"
end
