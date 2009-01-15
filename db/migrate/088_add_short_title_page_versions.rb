class AddShortTitlePageVersions < ActiveRecord::Migration
  def self.up
    add_column :page_versions, :short_title, :string
  end

  def self.down
    remove_column :page_versions, :short_title
  end
end
