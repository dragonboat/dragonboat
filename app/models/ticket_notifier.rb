class TicketNotifier < ActionMailer::Base
  def open(ticket)
    @recipients  = "#{ticket.email}"
    @from        = "#{APP_CONFIG['admin_email']}"
    @subject     =  "Your ticket##{ticket.id} has been created."
    setup_email(ticket)
  end
  
  def admin_notifier(ticket)
    @recipients  = "#{APP_CONFIG['admin_email']}"
    @from        = "Dragon Boat Site"
    @subject     =  "The ticket has been created. The ticket ID is ##{ticket.id}"
    @content_type = "text/html"  
    setup_email(ticket)
  end 
  
  private
  def setup_email(ticket)
    @sent_on     = Time.now
    @body[:ticket] = ticket  
    @body[:url_to_view] = ( ticket.user.nil? ? 
        url_for(:controller=>"support", :action=>"show",:id=>ticket.id,:host => APP_CONFIG['hostname']) :  
        url_for(:controller=>"member/support", :action=>"show",:id=>ticket.id,:host => APP_CONFIG['hostname'])
        )
  end
end
