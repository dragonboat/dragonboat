class RanameTypeOptions < ActiveRecord::Migration
  def self.up
    rename_column :volunteer_options, :type, :option_type
  end

  def self.down
    rename_column :volunteer_options, :option_type, :type
  end
end