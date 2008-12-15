class TicketNotifier < ActionMailer::Base
  def open(ticket)
    @recipients  = "#{ticket.email}"
    @from        = "#{APP_CONFIG['admin_email']}"
    @subject     =  "Your ticket##{ticket.id} has been created."
    @sent_on     = Time.now
    @body[:ticket] = ticket  
  end
  
  def admin_notifier(ticket)
    @recipients  = "#{APP_CONFIG['admin_email']}"
    @from        = "Dragon Boat Site"
    @subject     =  "The ticket has been created. The ticket ID is ##{ticket.id}"
    @sent_on     = Time.now
    @content_type = "text/html"  
    @body[:ticket] = ticket
  end 
end
