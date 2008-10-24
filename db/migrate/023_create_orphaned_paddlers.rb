class CreateOrphanedPaddlers < ActiveRecord::Migration
  def self.up
    create_table :orphaned_paddlers do |t|
      t.column :person_id, :integer
      t.column :note, :text
      t.timestamps 
    end
    add_index :orphaned_paddlers,:person_id
  end

  def self.down
    drop_table :orphaned_paddlers
  end
end
