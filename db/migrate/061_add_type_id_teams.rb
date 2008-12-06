class AddTypeIdTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :type_id, :integer
    add_index  :teams, :type_id
  end

  def self.down
    remove_column :teams, :type_id
  end
end
