class UpdateMemberTypes < ActiveRecord::Migration
  def self.up
    MemberType.enumeration_model_updates_permitted = true
    MemberType.find_by_name('member').destroy
    #Steersperson,Alternate
    MemberType.create(:name => 'steersperson')
    MemberType.create(:name => 'alternate')
  end

  def self.down
    MemberType.enumeration_model_updates_permitted = true
    MemberType.find_by_name('steersperson').destroy
    MemberType.find_by_name('alternate').destroy
    MemberType.create(:name => 'member')    
  end
end
