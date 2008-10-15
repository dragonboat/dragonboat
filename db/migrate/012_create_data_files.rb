class CreateDataFiles < ActiveRecord::Migration
  def self.up
    create_table :data_files do |t|
      t.column :parent_id,    :integer
      t.column :content_type, :string
      t.column :filename,     :string
      t.column :thumbnail,    :string
      t.column :size,         :integer
      t.column :width,        :integer
      t.column :height,       :integer
      t.column :description, :text
      t.column :created_by, :integer
      t.timestamps 
    end
    
    add_index :data_files, :created_by
    add_index :data_files, :parent_id
  end

  def self.down
    drop_table :data_files
  end
end
