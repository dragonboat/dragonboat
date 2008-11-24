class AddIsFirstVolunteers < ActiveRecord::Migration
  def self.up
    add_column :volunteers, :have_you_volunteered_before, :boolean
  end

  def self.down
    remove_column :volunteers, :have_you_volunteered_before
  end
end
