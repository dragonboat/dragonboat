class CreateVolunteerOptions < ActiveRecord::Migration
  def self.up
    create_table :volunteer_options do |t|
      t.column :volunteer_id, :integer
      t.column :type, :string
      t.column :option, :string
    end
    add_index :volunteer_options, :volunteer_id
  end

  def self.down
    drop_table :volunteer_options
  end
end
