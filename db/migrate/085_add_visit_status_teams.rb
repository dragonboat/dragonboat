class AddVisitStatusTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :visit_status, :string, :default=>"first_time"
  end

  def self.down
    remove_column :teams, :visit_status
  end
end
