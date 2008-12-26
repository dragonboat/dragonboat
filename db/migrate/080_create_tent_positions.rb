class CreateTentPositions < ActiveRecord::Migration
  def self.up
    create_table :tent_positions do |t|
      t.column :number, :integer
      t.column :status, :string, :limit=>50
      t.column :description, :text
      t.timestamps 
    end
    add_index :tent_positions, :status
    add_index :tent_positions, :number
  end

  def self.down
    drop_table :tent_positions
  end
end
