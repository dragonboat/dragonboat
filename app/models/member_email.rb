class MemberEmail < ActionMailer::Base
  
  def team_notifier(current_user,member, subject, body, sent_at = Time.now)
    @subject         = subject
    @body[:body]     = body
    @recipients      = member.user.email
    from = current_user ? "#{current_user.person.name} <#{current_user.email}>" : "Philadelphia Dragon Boat Festival <#{APP_CONFIG['noreply_email']}>" 
    @from            = from 
    @sent_on         = sent_at
    @headers         = {}
  end

end
