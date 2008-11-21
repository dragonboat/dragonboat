class CreateTeams < ActiveRecord::Migration
  def self.up
      create_table :teams do |t|
        t.column :name, :string
        t.column :description, :text
        t.column :captain_id, :integer
        t.column :logo_id, :integer
        t.timestamps 
      end
      add_index :teams, :captain_id
      add_index :teams, :logo_id
   end

   def self.down
     drop_table :teams
   end
end