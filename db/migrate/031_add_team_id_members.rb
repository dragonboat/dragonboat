class AddTeamIdMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :team_id, :integer
    add_index :members, :team_id
  end

  def self.down
    remove_column :members, :team_id
    remove_index :members, :team_id
  end
end
