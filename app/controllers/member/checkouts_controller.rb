class Member::CheckoutsController < Member::WebsiteController 
before_filter :has_any_boat?, :except=> :success
before_filter :fetch_team

include ActiveMerchant::Billing
ActiveMerchant::Billing::Base.mode = :test

 def index
    @order = Order.new
    

    @customer = current_user
    @person = current_user.person 
    @credit_card = ActiveMerchant::Billing::CreditCard.new(
                  :first_name         => 'Bob',
                  :last_name          => 'Bobsen',
                  :number             => '4242424242424242',
                  :month              => 8,
                  :year               => 2012,
                  :verification_value => '123'
                )
  
  rescue ActionController::RedirectBackError => e
    redirect_to '/'
  end
  
  def confirm_order
    return unless prepare_valid_order
  end
  
  def place_order
    return unless prepare_valid_order
    if @person.save && @customer.save
     @order.user = @customer
     @order.customer_ip = request.remote_ip
    end
    
    if @order.save && @team.save && @credit_card.valid?   
      gateway =  ActiveMerchant::Billing::Base.gateway(:trust_commerce).new(:login => "TestMerchant", :password => "password",:test => true)   

      options = {
        :ip => request.remote_ip,
        :email => @person.email,
        :billing_address => { 
          :name     => @person.name,
          :address1 => @person.address,
          :city     => @person.city,
          :state    => @person.state,
          :country  => @person.country,
          :zip      => @person.zip,
          :phone    => @person.phone
        },
        :order_id => @order.id
      }
      
     # @credit_card.number = '4242424242424242'
      begin
        #response = gateway.authorize(current_cart.total, @credit_card, options)
        # Authorize for the amount
        response = gateway.purchase(@team.total.to_i, @credit_card)
      rescue Exception => e
        @order.failed!
        flash.now[:notice] = "Please try again, error occurred while authorize payment #{e}"
        render :action => "index"
        return
      end
      
      @order.gateway_message = response.message
      if response.success?
        @order.process
        begin
          gateway.capture(@order.total_pay, response.authorization)
        rescue Exception => e
          @order.failed!
          flash.now[:notice] = "Please try again, error occurred while charging your credit card #{e}"
          render :action => "index"
          return
        end
        @order.activate
        redirect_to member_boat_checkout_url(@team.id,'success',@order.id)
      else
        @order.failed!
        flash.now[:notice] = "Transaction failed. #{response.message}"
        render :action => "index"
      end
    else
      flash.now[:notice] = "Please correct your details before you can continue"
      render :action => "index"
    end
  end
  
  def success
    @order =  Order.find(params[:id])
    @user = current_user
    @person = @user.person
  end
  
  protected
  def prepare_valid_order
    @order =  Order.new(params[:order])
    @order.team = @team
    @customer = current_user
    @person = @customer.person
   
  
    @person.attributes = (params[:person])
    @person.validation_mode = :order
    #@credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
    @credit_card = ActiveMerchant::Billing::CreditCard.new(
                  :first_name         => 'Bob',
                  :last_name          => 'Bobsen',
                  :number             => '4242424242424242',
                  :month              => 8,
                  :year               => 2012,
                  :verification_value => '123'
                )
    @order.credit_card = @credit_card
    if @order.valid? && @person.valid? && @customer.valid? && @credit_card.valid?
      return true
    else
      flash.now[:notice] = "Please correct your details before you can continue"
      render :action => "index"
      return false
    end
  end
end
