class AddStatusIdTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :status_id, :integer, :default=>Status.find_team_by_name('inactive').id
    add_index :teams, :status_id
  end

  def self.down
    remove_index :teams, :status_id
    remove_column :teams, :status_id
  end
end
