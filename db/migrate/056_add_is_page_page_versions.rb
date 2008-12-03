class AddIsPagePageVersions < ActiveRecord::Migration
  def self.up
    add_column :page_versions, :is_page, :boolean, :default=>1
    add_index :page_versions, :is_page
  end

  def self.down
    remove_column :page_versions, :is_page
  end
end
