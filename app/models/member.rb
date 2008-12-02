class Member < ActiveRecord::Base
  has_enumerated  :type, :class_name => 'MemberType',:foreign_key => 'type_id'
  has_enumerated  :invitation_status, :class_name => 'Status',:foreign_key => 'invitation_status_id'
  has_enumerated  :waiver_status, :class_name => 'Status',:foreign_key => 'waiver_status_id'
  belongs_to :user, :include=>[:person]
  belongs_to :team, :include=>[:captain]
  belongs_to :type, :class_name => 'MemberType',:foreign_key => 'type_id'
  belongs_to :invitation_status, :class_name => 'Status',:foreign_key => 'invitation_status_id'
  belongs_to :waiver_status, :class_name => 'Status',:foreign_key => 'waiver_status_id'
  
  scope_out :active,
            :conditions => "invitation_status_id=#{Status.find_invitation_by_name('confirmed').id} AND waiver_status_id=#{Status.find_waiver_by_name('accept').id}"
  scope_out :confirmed_and_unread,
            :conditions => "invitation_status_id=#{Status.find_invitation_by_name('confirmed').id} AND waiver_status_id=#{Status.find_waiver_by_name('unread').id}"        
  scope_out :accessible,
            :conditions => "invitation_status_id=#{Status.find_invitation_by_name('confirmed').id} AND waiver_status_id<>#{Status.find_waiver_by_name('decline').id}"        
  
  validates_presence_of  :type_id,:waiver_status_id,:invitation_status_id
  validates_associated :team, :user

  #invatation status : unconfirmed, confirmed
  #sign waver: unread, accept, decline
  def after_initialize
    self.waiver_status_id = Status.find_waiver_by_name('unread').id unless self.waiver_status_id 
    self.invitation_status_id = Status.find_invitation_by_name('unconfirmed').id unless self.invitation_status_id 
  end
  
  def invite
    unless self.invitation_status.name == 'confirmed'
      update_attribute(:invitation_status_id, Status.find_invitation_by_name('confirmed').id) 
      MemberNotifier.send("deliver_confirmed", self)
      true
    else
      false
    end
  end
  
  def after_destroy
    user.destroy
  end
  private

end
