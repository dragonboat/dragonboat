class RanamePriceToPriceToCents < ActiveRecord::Migration
  def self.up
    rename_column :boat_types, :price, :price_in_cents
    rename_column :extras, :price, :price_in_cents
  end

  def self.down
    rename_column :boat_types, :price_in_cents, :price
    rename_column :extras, :price_in_cents, :price
  end
end
