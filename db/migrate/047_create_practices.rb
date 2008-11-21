class CreatePractices < ActiveRecord::Migration
  def self.up
    create_table :practices do |t|
      t.column :status_id, :integer
      t.column :team_id, :integer
      t.column :description, :text
      t.column :name, :string
      t.timestamps 
    end
    add_index :practices, :status_id
    add_index :practices, :team_id
  end

  def self.down
    drop_table :practices
  end
end
