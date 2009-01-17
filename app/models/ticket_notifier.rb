class TicketNotifier < ActionMailer::Base
  include SupportHelper
  def open(ticket)
    @recipients  = "#{ticket.email}"
    @from        = "#{APP_CONFIG['admin_email']}"
    @subject     =  "Your ticket##{ticket.id} has been created. "
    @subject +=ticket.subject
    setup_email(ticket)
  end
  
  def reply(ticket) 
    @recipients  = "#{ticket.email}"
    @from        = "#{APP_CONFIG['admin_email']}"
    @subject     =  ""
    setup_email(ticket)
    set_answer(ticket)    
  end 
  
  def pending(ticket)
    @recipients  = "#{ticket.email}"
    @from        = "#{APP_CONFIG['admin_email']}"
    @subject     =  "Your ticket##{ticket.id} has been pending."
    setup_email(ticket)
    set_answer(ticket)    
  end 
  
  def review(ticket) 
    @recipients  = "#{ticket.email}"
    @from        = "#{APP_CONFIG['admin_email']}"
    @subject     =  "Your ticket##{ticket.id} has been reviewed."
    setup_email(ticket) 
    set_answer(ticket)
  end 
  
  def closed(ticket)
    @recipients  = "#{ticket.email}"
    @from        = "#{APP_CONFIG['admin_email']}"
    @subject     =  "Your ticket##{ticket.id} has been closed."
    setup_email(ticket)    
    set_answer(ticket)   
  end
  
  def admin_notifier(ticket)
    @recipients  = "#{APP_CONFIG['admin_email']}"
    @from        = "#{APP_CONFIG['noreply_email']}"
    @subject     =  "The ticket##{ticket.id} has been created. "
    @subject +=ticket.subject
    @content_type = "text/html"  
    setup_email(ticket)
  end 
  
  private
  def setup_email(ticket)
    @sent_on     = Time.now
    @body[:ticket] = ticket  
    #History
    @body[:history] = history(ticket)
    @body[:url_to_view] = ( ticket.user.nil? ? 
        url_for(:controller=>"support", :action=>"show",:id=>ticket.id,:host => APP_CONFIG['hostname']) :  
        url_for(:controller=>"member/support", :action=>"show",:id=>ticket.id,:host => APP_CONFIG['hostname'])
        )
  end
  
  def set_answer(ticket)
    str = ''
    answer = ticket.answers.find(:all, :order=>"created_at DESC", :limit=>"1").first
    return unless answer
    message = answer.message
    str = @subject
    str+="\n"+message #if !message.empty?
    answer.update_attribute(:message, str )
    @body[:answer] = answer.reload.message
    @subject +="Re: "+ticket.subject
  end
  
end
