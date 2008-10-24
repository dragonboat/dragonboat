class CreateVolunteers < ActiveRecord::Migration
  def self.up
    create_table :volunteers do |t|
      t.column :person_id, :integer
      t.column :date_applied, :datetime
      t.column :status_id, :integer
      t.column :note, :text
      t.timestamps 
    end
    add_index :volunteers, :person_id
    add_index :volunteers, :status_id
  end

  def self.down
    drop_table :volunteers
  end
end
