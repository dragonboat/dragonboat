class AddAddress2Persons < ActiveRecord::Migration
  def self.up
    add_column :persons, :address2, :string
  end

  def self.down
    remove_column :persons, :address2
  end
end
