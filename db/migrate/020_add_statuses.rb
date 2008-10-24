class AddStatuses < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.create(:name => 'applied')
    status.update_attribute(:type, "Volunteer")
    status = Status.create(:name => 'accepted')
    status.update_attribute(:type, "Volunteer")
    status = Status.create(:name => 'declined')
    status.update_attribute(:type, "Volunteer")
  end

  def self.down
  end
end
