class AddInvitationStatus < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.create(:name => 'unconfirmed')
    status.update_attribute(:type, "Invitation")
    status = Status.create(:name => 'confirmed')
    status.update_attribute(:type, "Invitation")
  end

  def self.down
  end
end
