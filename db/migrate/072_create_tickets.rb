class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.column :parent_id, :integer
      t.column :user_id, :integer
      t.column :email, :string
      t.column :subject, :string
      t.column :priority, :string, :limit=>50
      t.column :status, :string, :limit=>50
      t.column :message, :text
      t.column :category_id, :integer
      t.timestamps 
    end
    
    add_index :tickets, :parent_id
    add_index :tickets, :priority
  end

  def self.down
    drop_table :tickets
  end
end
