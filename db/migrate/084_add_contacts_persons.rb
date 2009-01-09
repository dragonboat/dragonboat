class AddContactsPersons < ActiveRecord::Migration
  def self.up
    add_column :persons, :emergency_contact_name, :string
    add_column :persons, :emergency_contact_number, :string
    add_column :persons, :medical_conditions, :text
  end

  def self.down
    remove_column :persons, :emergency_contact_name
    remove_column :persons, :emergency_contact_number
    remove_column :persons, :medical_conditions
  end
end
