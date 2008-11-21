class RemoveCaptainTypes < ActiveRecord::Migration
  def self.up
    MemberType.enumeration_model_updates_permitted = true
    MemberType.find_by_name('captain').destroy
  end

  def self.down
    MemberType.enumeration_model_updates_permitted = true
    MemberType.create(:name => 'captain')
  end
end