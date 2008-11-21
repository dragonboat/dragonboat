class OrderNotifier < ActionMailer::Base
  def processed(order, sent_at = Time.now)
    setup_email(order, sent_at)
  end
  
  private
  def setup_email(order, sent_at)
    @subject            = "Dragonboat Order##{order.id} #{order.status}"
    @body[:order]       = order
    @recipients         = order.user.person.email
    @from               = "#{APP_CONFIG["admin_email"]}"
    @sent_on            = sent_at
    @headers            = {}
  end

end
