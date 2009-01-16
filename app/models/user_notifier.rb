class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Account Created: Philadelphia International Dragon Boat Festival Website'
    @body[:url]  = "http://#{APP_CONFIG["hostname"]}/"
  end
  
  def password_changed(user, new_password)
    setup_email(user)
    @subject = 'philadragonboatfestival.com: password changed'
    @from = "#{APP_CONFIG['admin_email']}"  
    @content_type = "text/html"
    @body[:new_password] = new_password
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "#{APP_CONFIG['noreply_email']}"
    @subject     = ""
    @sent_on     = Time.now
    @body[:user] = user
  end

end
