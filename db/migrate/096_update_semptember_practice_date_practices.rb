class UpdateSemptemberPracticeDatePractices < ActiveRecord::Migration
  def self.up
  #September: Monday – Thursday(1-4) – 6pm & 7pm (2 at each hour)
  #Exceptions:
  #Saturday, September 12th, practices start at 12
  #Sunday, September 20th practices start at 1 PM
  #Saturday, September 26th - No practices at all
   start_date = Date.new(2009,9).beginning_of_month #September
   end_date = Date.new(2009,9).end_of_month #September
   start_date.upto(end_date) do |date| 
     # 0..6, with Sunday == 0. 
     if [1,2,3,4].include?(date.wday)
       p_times = [Time.local(date.year,date.month,date.day, 18, 0)]
       p_times << Time.local(date.year,date.month,date.day, 19, 0)
       p_times.each do |p_time|
        2.times { Practice.create(:created_at=>p_time)}
       end
     #September: Saturday & Sunday 8am – 3pm (2 per hour)
     #Saturday, September 26th - No practices at all
     elsif [6,0].include?(date.wday) && date.day != 26
       p_times = []
       #Sunday, September 20th practices start at 1 PM
       if 12 == date.day
        start_time  = 12
        end_time = 15
       #Saturday, September 12th, practices start at 12
       elsif 20 == date.day
        start_time  = 13
        end_time = 15  
       else
        start_time  = 8
        end_time = 15
       end
       
       start_time.upto(end_time) {|h| p_times << Time.local(date.year,date.month,date.day, h, 0)}
       p_times.each do |p_time|
        2.times { Practice.create(:created_at=>p_time)}
       end
     end
     
   end 
  end

  def self.down
  end
end
