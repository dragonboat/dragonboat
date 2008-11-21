class CreateTents < ActiveRecord::Migration
  def self.up
    create_table :tents do |t|
      t.column :team_id, :integer
      t.column :location, :string
      t.timestamps 
    end
    add_index :tents, :team_id
  end

  def self.down
    drop_table :tents
  end
end
