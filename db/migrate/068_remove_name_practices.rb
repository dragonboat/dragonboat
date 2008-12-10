class RemoveNamePractices < ActiveRecord::Migration
  def self.up
    remove_column :practices, :name
    remove_column :practices, :description
  end

  def self.down
    add_column :practices, :name, :string
    add_column :practices, :description, :text
  end
end
