class AddHumanNameTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :human_name, :string
  end

  def self.down
    remove_column :teams, :human_name, :string
  end
end
