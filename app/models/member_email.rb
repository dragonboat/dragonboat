class MemberEmail < ActionMailer::Base
  
  def team_notifier(member, subject, body, sent_at = Time.now)
    @subject         = subject
    @body[:body]     = body
    @recipients        = member.user.email
    @from              = "Philadelphia Dragon Boat Festival <#{APP_CONFIG['noreply_email']}>" 
    @sent_on           = sent_at
    @headers           = {}
  end

end
