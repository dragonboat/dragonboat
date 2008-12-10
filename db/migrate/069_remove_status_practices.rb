class RemoveStatusPractices < ActiveRecord::Migration
  def self.up
    remove_column :practices, :status_id
  end

  def self.down
    add_column :practices, :status_id, :integer
  end
end
