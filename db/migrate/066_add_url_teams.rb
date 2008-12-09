class AddUrlTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :url, :string
  end

  def self.down
    remove_column :teams, :url
  end
end
