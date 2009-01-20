class ClearDb < ActiveRecord::Migration
  def self.up
   #Delete all users except "admin/admin" from the database, 
   #and delete all teams/paddlers/orders/etc, but NOT content
   Member.find(:all).each {|o| o.destroy }
   OrphanedPaddler.find(:all).each {|o| o.destroy }
   Volunteer.find(:all).each {|o| o.destroy }
   Ticket.find(:all).each {|o| o.destroy }
   Team.find(:all).each {|o| o.destroy }
   Order.find(:all).each {|o| o.destroy }
   User.find(:all).each {|o| o.destroy if o.login != 'admin'}
   TentPosition.find(:all).each {|t| t.update_attribute(:status, "available") }
  end

  def self.down
  end
end
