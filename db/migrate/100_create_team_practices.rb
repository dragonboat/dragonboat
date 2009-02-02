class CreateTeamPractices < ActiveRecord::Migration
  def self.up
    create_table :team_practices do |t|
      t.column :team_id, :integer
      t.timestamps 
    end
  end

  def self.down
    drop_table :team_practices
  end
end
