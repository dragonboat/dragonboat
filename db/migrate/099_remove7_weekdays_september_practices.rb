class Remove7WeekdaysSeptemberPractices < ActiveRecord::Migration
  def self.up
     start_date = Date.new(2009,9).beginning_of_month #September
   end_date = Date.new(2009,9).end_of_month #September
   say "Start September practices deleting"
   start_date.upto(end_date) do |date| 
     # 0..6, with Sunday == 0. 
     if [1,2,3,4].include?(date.wday)
       p_time = Time.local(date.year,date.month,date.day, 19, 0)
       
       Practice.find(:all, :conditions=>["created_at=?",p_time.to_s(:db)]).each do |p|
         team = p.team
         if team 
           begin
             TeamNotifier.send("deliver_cancel_practices", team)
             say "Team ID: #{team.id}: E-mail was sent successfully"
           rescue Exception 
             say "ERROR: Team ID: #{team.id} Please try again, error occurred while re-sending the invitation #{e}"
           end 
         end
         p.destroy
       end
     end
   end
   say "End September practices deleting"
  end

  def self.down
  end
end
