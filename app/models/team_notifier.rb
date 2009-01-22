class TeamNotifier < ActionMailer::Base
  
  def cancel_practices(team, sent_at = Time.now)
    setup_email(team, sent_at)
  end
  
 
  private
  def setup_email(team, sent_at)
    @subject            = "philadragonboatfestival.com: September Practice Cancelled"
    @body[:team]       = team
    @recipients         = team.captain.email
    @from               = "Philadelphia Dragon Boat Festival <#{APP_CONFIG['noreply_email']}>" 
    @sent_on            = sent_at
    @headers            = {}
  end

end
