class AddInvitationStatus < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.create(:name => 'unconfirmed')
    status.update_attribute(:status_type, "Invitation")
    status = Status.create(:name => 'confirmed')
    status.update_attribute(:status_type, "Invitation")
  end

  def self.down
  end
end
