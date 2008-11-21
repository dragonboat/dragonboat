class AddColumnsPersons < ActiveRecord::Migration
  def self.up
    add_column :persons, :city, :string
    add_column :persons, :state, :string
    add_column :persons, :country, :string
  end

  def self.down
    remove_column :persons, :city
    remove_column :persons, :state
    remove_column :persons, :country
  end
end
