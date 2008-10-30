class VolunteerNotifier < ActionMailer::Base
  
  def message(volunteer,subject,message)
    @recipients  = "#{volunteer.person.email}"
    @from        = APP_CONFIG['admin_email']
    @subject     = subject
    @sent_on     = Time.now
    @body[:volunteer] = volunteer  
    @content_type = "text/html"
    @body[:message] = message
  end

end
