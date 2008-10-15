class AddCreatedByImages < ActiveRecord::Migration
  def self.up
    add_column :images, :created_by, :integer
    add_index :images, :created_by
  end

  def self.down
    remove_column :images, :created_by
  end
end
