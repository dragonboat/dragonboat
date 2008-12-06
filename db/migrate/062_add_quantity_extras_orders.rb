class AddQuantityExtrasOrders < ActiveRecord::Migration
  def self.up
    add_column :extras_orders, :quantity, :integer
  end

  def self.down
    remove_column :extras_orders, :quantity, :integer
  end
end
