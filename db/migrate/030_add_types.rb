class AddTypes < ActiveRecord::Migration
  def self.up
    MemberType.enumeration_model_updates_permitted = true
    MemberType.create(:name => 'captain')
    MemberType.create(:name => 'paddler')
    MemberType.create(:name => 'member')
  end

  def self.down
  end
end
