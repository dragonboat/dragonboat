class Admin::OrdersController < Admin::WebsiteController
  
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
    
    @orders = Order.paginate(:page => params[:page], 
                              :include=>[:person],
                                :per_page =>APP_CONFIG["admin_per_page"],
                                :order => order)
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
  
end
