class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :start_date, :datetime
      t.column :name, :string
      t.column :content, :text
      t.timestamps 
    end
  end

  def self.down
    drop_table :events
  end
end
