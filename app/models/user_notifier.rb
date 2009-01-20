class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Account Created: Philadelphia International Dragon Boat Festival Website'
    @body[:url]  = "http://#{APP_CONFIG["hostname"]}/"
  end
  
  def password_changed(user, new_password)
    setup_email(user)
    @subject = 'philadragonboatfestival.com: password changed'  
    @content_type = "text/html"
    @body[:new_password] = new_password
  end
  
  def invite_to_change_password(user)
    setup_email(user)
    @subject = 'philadragonboatfestival.com: reset password'
    @content_type = "text/html"
    @body[:url] = "http://#{APP_CONFIG["hostname"]}/change_password/#{user.code}"
  end
  
  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "Philadelphia Dragon Boat Festival <#{APP_CONFIG['noreply_email']}>" 
    @subject     = ""
    @sent_on     = Time.now
    @body[:user] = user
  end

end
