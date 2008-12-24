class RenameUnactiveTeamsStatuses < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.create(:name => 'inactive')
    status.update_attribute(:status_type, "Team")
    status = Status.find_by_name('unactive')
    status.destroy
  end

  def self.down
  end
end
