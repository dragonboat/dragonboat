class MemberObserver < ActiveRecord::Observer
  def after_create(member)
    if %w(confirmed).include?(member.invitation_status.name)
      MemberNotifier.send("deliver_confirmed", member)
    end
  end
end
