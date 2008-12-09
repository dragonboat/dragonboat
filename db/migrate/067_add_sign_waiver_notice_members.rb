class AddSignWaiverNoticeMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :sign_waiver_notice, :string
  end

  def self.down
    remove_column :members, :sign_waiver_notice
  end
end
