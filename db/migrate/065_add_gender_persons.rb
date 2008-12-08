class AddGenderPersons < ActiveRecord::Migration
  def self.up
    add_column :persons, :gender, :string, :length=>1
  end

  def self.down
    remove_column :persons, :gender
  end
end
