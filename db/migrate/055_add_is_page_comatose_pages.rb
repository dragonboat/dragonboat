class AddIsPageComatosePages < ActiveRecord::Migration
  def self.up
    add_column :comatose_pages, :is_page, :boolean, :default=>1
    add_index :comatose_pages, :is_page
  end

  def self.down
    remove_column :comatose_pages, :is_page
  end
end
