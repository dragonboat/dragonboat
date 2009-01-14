class MemberNotifier < ActionMailer::Base
  def unconfirmed(member, sent_at = Time.now)
    team = member.team
    captain = team.captain
    @subject           = "Invitation to join the team #{team.name}"
    @body[:member]     = member
    @body[:team]       = team
    @body[:captain]    = captain
    @body[:code_url]   = team_url_code_url(:slug => team.name.to_slug, :url_code => member.user.code, :host => APP_CONFIG['hostname'])
    @body[:code_url_form]  = team_confirm_form_url(:host => APP_CONFIG['hostname'])
    @body[:code]  = member.user.code

    @recipients        = member.user.email
    @from              = "noreply@phillydragonboat.info" #captain.email
    @sent_on           = sent_at
    @headers           = {}
  end
  
end
