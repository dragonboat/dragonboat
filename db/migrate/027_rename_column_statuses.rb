class RenameColumnStatuses < ActiveRecord::Migration
  def self.up
    rename_column :statuses, :type, :status_type
  end

  def self.down
    rename_column :statuses, :status_type, :type
  end
end
