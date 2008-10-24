class CreatePersons < ActiveRecord::Migration
  def self.up
    create_table :persons do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email, :string
      t.column :phone, :string
      t.column :phone_2, :string
      t.column :birthday_date, :date
      t.column :zip, :string
      t.column :address, :string
      t.column :experience, :text
      t.column :preference, :text
      t.column :note, :text
      t.timestamps 
    end
  end

  def self.down
    drop_table :persons
  end
end
