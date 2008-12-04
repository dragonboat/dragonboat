class AddNoticeComatosePages < ActiveRecord::Migration
  def self.up
    add_column :comatose_pages, :notice, :string
    add_column :page_versions, :notice, :string
  end

  def self.down
    remove_column :comatose_pages, :notice, :string
    remove_column :page_versions, :notice, :string
  end
end
