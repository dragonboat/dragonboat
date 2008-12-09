class MemberObserver < ActiveRecord::Observer
  def after_create(member)
    if %w(unconfirmed).include?(member.invitation_status.name)
      MemberNotifier.send("deliver_unconfirmed", member)
    end
  end
end
