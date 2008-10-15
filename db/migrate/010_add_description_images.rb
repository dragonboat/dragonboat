class AddDescriptionImages < ActiveRecord::Migration
  def self.up
    add_column :images, :description, :text
  end

  def self.down
    remove_column :images, :description
  end
end
