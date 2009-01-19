class OrderNotifier < ActionMailer::Base
  def processed(order, sent_at = Time.now)
    setup_email(order, sent_at)
  end
  
  def admin(order, sent_at = Time.now)
    @subject            = "Dragonboat Order##{order.id} #{order.status}"
    @body[:order]       = order
    @recipients         = "#{APP_CONFIG["order_email"]}"
    @sent_on            = sent_at
    @body[:order_details_path] = admin_order_url(:id=>order.id,:host => APP_CONFIG['hostname'])
    @headers            = {}
  end
  
  private
  def setup_email(order, sent_at)
    @subject            = "Registration Confirmation: #{order.team.name}"
    @body[:order]       = order
    @recipients         = order.user.person.email
    @from               = "#{APP_CONFIG['noreply_email']}" 
    @sent_on            = sent_at
    @headers            = {}
  end

end
