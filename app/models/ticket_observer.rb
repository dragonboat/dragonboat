class TicketObserver < ActiveRecord::Observer
  def after_create(ticket)
    TicketNotifier.deliver_open(ticket)
    TicketNotifier.deliver_admin_notifier(ticket)
  end
  
  def after_update(ticket)
    if %w(pending review closed).include?(ticket.status)
      TicketNotifier.send("deliver_#{ticket.status}", ticket)
    end
  end
end
