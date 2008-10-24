class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.column :title, :string
      t.column :description, :text
      t.column :content, :text
      t.column :cover_image_id, :integer
      t.column :is_short, :boolean, :default=>nil
      t.column :is_visible, :boolean, :default=>true
      t.column :data_is_visible, :boolean, :default=>true
      t.column :created_by, :integer
      t.column :created_at, :datetime
      t.column :published_at, :datetime, :comment => ""
      t.column :updated_at, :datetime
    end
    
    add_index :news, :cover_image_id
    add_index :news, :created_by
    add_index :news, :is_visible
    add_index :news, :is_short
    add_index :news, :data_is_visible
  end

  def self.down
    drop_table :news
  end
end

