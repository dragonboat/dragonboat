class CreateTeamExtras < ActiveRecord::Migration
  def self.up
    create_table :team_extras do |t|
      t.column :extras_id, :integer
      t.column :team_id, :integer
      t.column :quantity, :integer
      t.timestamps 
    end
    add_index :team_extras, :extras_id
    add_index :team_extras, :team_id
  end

  def self.down
    drop_table :team_extras
  end
end
