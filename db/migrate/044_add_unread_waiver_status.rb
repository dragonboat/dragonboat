class AddUnreadWaiverStatus < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.create(:name => 'unread')
    status.update_attribute(:status_type, "Waiver")
  end

  def self.down
    Status.enumeration_model_updates_permitted = true
    Status.find_by_name('unread').destroy
  end
end
