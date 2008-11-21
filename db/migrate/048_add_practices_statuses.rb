class AddPracticesStatuses < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.create(:name => 'available')
    status.update_attribute(:status_type, "Practice")
    status = Status.create(:name => 'unavailable')
    status.update_attribute(:status_type, "Practice")
  end

  def self.down
  end
end
