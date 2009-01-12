class AddShortTitlePages < ActiveRecord::Migration
  def self.up
    add_column :comatose_pages, :short_title, :string
  end

  def self.down
    remove_column :comatose_pages, :short_title
  end
end
