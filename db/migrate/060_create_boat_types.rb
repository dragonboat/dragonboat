class CreateBoatTypes < ActiveRecord::Migration
  def self.up
    create_table :boat_types do |t|
      t.column :name, :string
      t.column :price, :integer
      t.column :is_active, :boolean, :default=>0
      t.timestamps 
    end
    add_index :boat_types, :is_active
  end

  def self.down
    drop_table :boat_types
  end
end
