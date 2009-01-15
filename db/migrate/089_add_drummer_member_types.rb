class AddDrummerMemberTypes < ActiveRecord::Migration
  def self.up
    MemberType.enumeration_model_updates_permitted = true
    #Drummer
    MemberType.create(:name => 'drummer')
  end

  def self.down
    MemberType.enumeration_model_updates_permitted = true
    MemberType.find_by_name('drummer').destroy
  end
end
