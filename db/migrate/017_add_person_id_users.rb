class AddPersonIdUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :person_id, :integer
    add_index  :users, :person_id
  end

  def self.down
    remove_column :users, :person_id
  end
end
