class AddWaiverStatus < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.create(:name => 'decline')
    status.update_attribute(:status_type, "Waiver")
    status = Status.create(:name => 'accept')
    status.update_attribute(:status_type, "Waiver")
  end

  def self.down
  end
end
