class AddUpdatedByTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :updated_by, :integer
  end

  def self.down
    remove_column :tickets, :updated_by
  end
end
