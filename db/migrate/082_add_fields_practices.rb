class AddFieldsPractices < ActiveRecord::Migration
  def self.up
    add_column :practices, :launch_driver, :text
    add_column :practices, :steers_person, :text
  end

  def self.down
    remove_column :practices, :launch_driver, :text
    remove_column :practices, :steers_person, :text
  end
end
