class AddCocaptainMemberTypes < ActiveRecord::Migration
  def self.up
    MemberType.enumeration_model_updates_permitted = true
    #Co-captain
    MemberType.create(:name => 'co-captain')
  end

  def self.down
    MemberType.enumeration_model_updates_permitted = true
    MemberType.find_by_name('co-captain').destroy
  end
end
