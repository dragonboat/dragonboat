require 'event'
class EventTasks 
  def self.move_time_to_start_date
    print "Start moving time form created_at to start_date\n"
    Event.connection.execute("Update events SET start_date = CONCAT(DATE_FORMAT(start_date,'%Y-%m-%d'), TIME_FORMAT(created_at, ' %H:%i:00'))")
    print "End moving time form created_at to start_date"
  end
end
