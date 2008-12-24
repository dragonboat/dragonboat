class AddSignWaiverInfoMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :ip, :string, :default=>""
    add_column :members, :waiver_sign_at, :datetime
  end

  def self.down
    remove_column :members, :ip
    remove_column :members, :waiver_sign_at
  end
end
