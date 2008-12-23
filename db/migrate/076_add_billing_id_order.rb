class AddBillingIdOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :billing_id, :integer
    add_index :orders, :billing_id
  end

  def self.down
    remove_column :orders, :billing_id
  end
end
