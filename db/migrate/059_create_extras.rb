class CreateExtras < ActiveRecord::Migration
  def self.up
    create_table :extras do |t|
      t.column :name, :string
      t.column :price, :integer
      t.column :notice, :text
      t.column :is_available, :boolean, :default=>0
      t.timestamps 
    end
    add_index :extras, :is_available
  end

  def self.down
    drop_table :extras
  end
end
