class RenameUnactiveTeamsStatuses < ActiveRecord::Migration
  def self.up
    Status.enumeration_model_updates_permitted = true
    status = Status.find_by_name('unactive')
    if status
      status.destroy
      status = Status.create(:name => 'inactive')
      status.update_attribute(:status_type, "Team")
    end  
  end

  def self.down
  end
end
