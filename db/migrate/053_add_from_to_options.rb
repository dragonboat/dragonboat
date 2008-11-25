class AddFromToOptions < ActiveRecord::Migration
  def self.up
    add_column :volunteer_options, :from, :time
    add_column :volunteer_options, :to, :time
  end

  def self.down
    remove_column :volunteer_options, :from
    remove_column :volunteer_options, :to
  end
end
