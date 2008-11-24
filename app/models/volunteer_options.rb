class VolunteerOptions < ActiveRecord::Base 
   belongs_to :volunteer
   TIMES_AVAILABLE = [{:name=>"Set up - 6am to 7am", :id=>"set_up"},
                      {:name=>"Morning Shift - 6:30 am to 11:30 am", :id=>"morning_shift"},
                      {:name=>"Afternoon Shift - 11:30 am to 6:00 pm", :id=> "afternoon_shift"},
                      {:name=>"All Day", :id=> "all_day"},
                      {:name=>"As Needed", :id=> "as_needed" }
                      ]

end
