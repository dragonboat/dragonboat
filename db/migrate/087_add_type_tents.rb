class AddTypeTents < ActiveRecord::Migration
  def self.up
    add_column :tents, :t_type, :string, :limit=>50, :default=>'main'
    add_index :tents, :t_type
  end

  def self.down
    remove_column :tents, :t_type
  end
end
