class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.column :type_id, :integer
      t.column :user_id, :integer
      t.column :invitation_status_id, :integer
      t.column :waiver_status_id, :integer
      t.timestamps 
    end
    add_index :members, :type_id
    add_index :members, :user_id
    add_index :members, :invitation_status_id
    add_index :members, :waiver_status_id
  end

  def self.down
    drop_table :members
  end
end
