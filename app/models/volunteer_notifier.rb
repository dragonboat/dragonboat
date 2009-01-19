class VolunteerNotifier < ActionMailer::Base
  
  def message(volunteer,subject,message)
    @recipients  = "#{volunteer.person.email}"
    @from        = "Philadelphia Dragon Boat Festival <#{APP_CONFIG['noreply_email']}>" 
    @subject     = subject
    @sent_on     = Time.now
    @body[:volunteer] = volunteer  
    @content_type = "text/html"
    @body[:message] = message
  end

end
