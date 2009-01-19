class UpdatePracticeDatePractices < ActiveRecord::Migration
  def self.up
   #July & August: Monday – Thursday(1-4) – 6pm & 7pm (2 at each hour) 
   Practice.delete_all
   start_date = Date.new(2009,7).beginning_of_month #July 
   end_date = Date.new(2009,8).end_of_month #August
   start_date.upto(end_date) do |date| 
     # 0..6, with Sunday == 0. 
     if [1,2,3,4].include?(date.wday)
       p_times = [Time.local(date.year,date.month,date.day, 18, 0)]
       p_times << Time.local(date.year,date.month,date.day, 19, 0)
       p_times.each do |p_time|
        2.times { Practice.create(:created_at=>p_time)}
       end
     #July & August: Saturday & Sunday 8am – 3pm (2 per hour)
     elsif [6,0].include?(date.wday)
       p_times = []
       8.upto(15) {|h| p_times << Time.local(date.year,date.month,date.day, h, 0)}
       p_times.each do |p_time|
        2.times { Practice.create(:created_at=>p_time)}
       end
     end
     
   end 
  end

  def self.down
    Practice.delete_all
  end
end
