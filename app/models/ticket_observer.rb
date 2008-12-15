class TicketObserver < ActiveRecord::Observer
  def after_create(ticket)
    TicketNotifier.deliver_open(ticket)
    TicketNotifier.deliver_admin_notifier(ticket)
  end
end
