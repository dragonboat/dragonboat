class Member::CheckoutsController < Member::WebsiteController 
before_filter :has_any_boat?, :except=> :success
before_filter :fetch_team

include ActiveMerchant::Billing
ActiveMerchant::Billing::Base.mode = :test

 def index
    @order = Order.new
    

    @customer = current_user
    @person = current_user.person 
    if ActiveMerchant::Billing::Base.mode == :test
      @credit_card = ActiveMerchant::Billing::CreditCard.new(
                  :first_name         => 'Bob',
                  :last_name          => 'Bobsen',
                  :number             => '4242424242424242',
                  :month              => 8,
                  :year               => 2012,
                  :verification_value => '123'
                )
    else
       @credit_card = ActiveMerchant::Billing::CreditCard.new
    end
  
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
      #test Account
      gateway = ActiveMerchant::Billing::CyberSourceGateway.new(
        :login => "pdb",
        :password => "bj9yrrlVVRW0FATdmJliT23rFgdZmQj9tVGD8KBUjhQIgtyThLRK6/ln987IUDoR0ZC9QiBYxCS8OlhdYWOpJOAQGdyvT6bb0496RuzWN05qypZiN0WzCgWCFFayp5LvdZgag8SbvKBjC1rgB3aCXknzVccgYqm+Ro47GeQpDpZpFW3enORYUY+tfzPbsQ1PbesWB1mZCP21UYPwoFSOFAiC3JOEtErr+Wf3zshQOhHRkL1CIFjEJLw6WF1hY6kk4BAZ3K9PptvTj3pG7NY3TmrKlmI3RbMKBYIUVrKnku91mBqDxJu8oGMLWuAHdoJeSfNVxyBiqb5GjjsZ5CkOlg==",
        :test=> true,
        :ignore_avs => true,  
        :ignore_cvv => true
      )
      
      options = {
        :ip => request.remote_ip,
        :email => @person.email,
        :address => { 
        :address1 => @person.address,
        :address2 =>  @person.address2,
        :city =>  @person.city,
        :state => @person.state,
        :zip => @person.zip,
        :country => @person.country,
        :phone => @person.phone
      },
        :currency => 'USD',
        :order_id => @order.id,
        :ignore_avs => 'true',
        :ignore_cvv => 'true'
      }

      begin
        # Authorize for the amount
        # Amount is in cents
        response = gateway.authorize(@team.total.to_f * 100, @credit_card, options)
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
          # Amount is in cents
          gateway.capture(@order.total_pay.to_f * 100, response.authorization)
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
    @credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
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
