class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.column :name, :string
      t.column :type, :string
      t.timestamps 
    end
  end

  def self.down
    drop_table :statuses
  end
end
