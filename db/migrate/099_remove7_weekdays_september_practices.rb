class Remove7WeekdaysSeptemberPractices < ActiveRecord::Migration
  def self.up
     start_date = Date.new(2009,9).beginning_of_month #September
   end_date = Date.new(2009,9).end_of_month #September
   start_date.upto(end_date) do |date| 
     # 0..6, with Sunday == 0. 
     if [1,2,3,4].include?(date.wday)
       p_time = Time.local(date.year,date.month,date.day, 19, 0)
       Practice.delete_all(:created_at=>p_time.to_s(:db))
     end
   end
  end

  def self.down
  end
end
