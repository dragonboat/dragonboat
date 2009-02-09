class Admin::OrdersController < Admin::WebsiteController
  require 'fastercsv'
  include ActionView::Helpers::NumberHelper
  before_filter :set_view, :get_view
  
  def index
    order = case params[:sort]
      when 'created_at'             then 'orders.created_at'
      when 'created_at_reverse'     then 'orders.created_at DESC'
      when 'status'                 then 'orders.status'
      when 'status_reverse'         then 'orders.status DESC'
      when 'total'                  then 'orders.total_pay'
      when 'total_reverse'          then 'orders.total_pay DESC'
      when 'customer'               then 'persons.first_name, persons.last_name, persons.email'
      when 'customer_reverse'       then 'persons.first_name DESC, persons.last_name DESC, persons.email DESC' 
      when 'credit_cart'            then 'SUBSTRING_INDEX(SUBSTRING_INDEX(credit_card, "type:", -1), "\\n", 1 )'
      when 'credit_cart_reverse'    then 'SUBSTRING_INDEX(SUBSTRING_INDEX(credit_card, "type:", -1), "\\n", 1 ) DESC'  
      else 'orders.created_at DESC'
    end
    
    if @view == 'processed'
      conditions = "status='processed'"
    elsif @view == 'failed'
      conditions = "status='failed'"
    else
      conditions = nil
    end
    @orders = Order.paginate(:page => params[:page], 
                              :include=>[:person],
                                :per_page =>APP_CONFIG["admin_per_page"],
                                :order => order,
                              :conditions => conditions)
    @orders_count = Order.count(:conditions => conditions)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end
  
  def show
    @order = Order.find(params[:id])
    @person = @order.person ? @order.person : @order.user.person
    @team = @order.team
    @credit_card = @order.credit_card
  end
  
  def send_order_confirm
    @order = Order.find(params[:id])
    begin
    OrderNotifier.send("deliver_processed", @order)
    rescue Exception 
      flash[:notice] = "Please try again, error occurred while re-sending the order confirmation to the user who place it #{e}"
      redirect_to :action=>"show", :id=>@order.id
    end
    flash[:notice] = "The order confirmation e-mail  was successfully re-sent to the user < #{@order.person.email} >"
    redirect_to :action=>"index"
  end
  
  #Orders to CSV
  #Captain Name, Team Name, Team Type, Name On Card, Card Type, Total Charged, Date/Time, Total Tents.
  def orders_processed_to_csv
    @orders = Order.find(:all,:include=>[:person],:order => "orders.created_at DESC", :conditions =>"status='processed'")
    csv_str = FasterCSV.generate do |csv|
      csv << ["Captain Name", "Team Name", "Team Type", "Name On Card", "Card Type", 
              "Total Charged", "Date/Time", "Total Tents"]   
      @orders.each do |order|
        team = order.team
        captain = team.captain 
        credit_card = order.credit_card
        extras_orders = order.extras_orders.select {|o| o.extras.is_tent? }
        tents = 0
        extras_orders.each {|o| tents+=o.quantity}
        csv << [captain.person.name, CGI.unescapeHTML(team.name), team.boat_type_human, 
              "#{credit_card.first_name} #{credit_card.last_name}", credit_card.type.capitalize, 
              number_to_currency(order.total_pay), order.created_at.strftime("%d.%m.%Y/%H:%M"), tents]
      end
    end
    send_data csv_str, :type => 'text/csv', :disposition => "attachment;filename=orders_processed_to_csv.csv"
  end
  
  private
  def set_view
    session[:orders_view] = params[:view] if params[:view]
    session[:orders_view] = nil if params[:view_clear]
  end

  def get_view
    @view = session[:orders_view] ? session[:orders_view] : "all"
  end

end
