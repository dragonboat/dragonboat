class AddTeamsStatuses < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.create(:name => 'active')
    status.update_attribute(:status_type, "Team")
    status = Status.create(:name => 'unactive')
    status.update_attribute(:status_type, "Team")
  end

  def self.down
  end
end
