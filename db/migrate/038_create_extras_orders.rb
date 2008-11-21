class CreateExtrasOrders < ActiveRecord::Migration
  def self.up
    create_table :extras_orders do |t|
      t.column :order_id, :integer
      t.column :extras_id, :integer
      t.column :extras_type, :string
      t.column :pay, :integer
      t.timestamps 
    end
  end

  def self.down
    drop_table :extras_orders
  end
end
