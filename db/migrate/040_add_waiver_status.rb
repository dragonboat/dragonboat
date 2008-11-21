class AddWaiverStatus < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.create(:name => 'decline')
    status.update_attribute(:type, "Waiver")
    status = Status.create(:name => 'accept')
    status.update_attribute(:type, "Waiver")
  end

  def self.down
  end
end
