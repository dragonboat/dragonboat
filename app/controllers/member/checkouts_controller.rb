class Member::CheckoutsController < Member::WebsiteController 
before_filter :has_any_boat?, :except=> :success
before_filter :fetch_team
before_filter :secure_site
skip_before_filter :leave_secure_site

include ActiveMerchant::Billing
ActiveMerchant::Billing::Base.mode = :test#:live

 def index
    @order = Order.new
    

    @customer = current_user
    @person = current_user.person 
    @billing = Person.new
    #@credit_card = ActiveMerchant::Billing::CreditCard.new(:first_name=> 'Bob',:last_name=> 'Bobsen',:number => '4242424242424242', :month=>8, :year=> 2012,:verification_value => '123')
    @credit_card = ActiveMerchant::Billing::CreditCard.new
    params[:use_personal_address]="1"
    rescue ActionController::RedirectBackError => e  
    redirect_to '/'
  end
  
  def confirm_order
    return unless prepare_valid_order
  end
  
  def place_order
    return unless prepare_valid_order
    if @billing.save && @customer.save
     @order.user = @customer
     @order.customer_ip = request.remote_ip
    end
    
    if @order.save && @team.save && @credit_card.valid?   
      #test Account
      gateway = ActiveMerchant::Billing::CyberSourceGateway.new(
        #:login => "pdb",
        #:password => "bj9yrrlVVRW0FATdmJliT23rFgdZmQj9tVGD8KBUjhQIgtyThLRK6/ln987IUDoR0ZC9QiBYxCS8OlhdYWOpJOAQGdyvT6bb0496RuzWN05qypZiN0WzCgWCFFayp5LvdZgag8SbvKBjC1rgB3aCXknzVccgYqm+Ro47GeQpDpZpFW3enORYUY+tfzPbsQ1PbesWB1mZCP21UYPwoFSOFAiC3JOEtErr+Wf3zshQOhHRkL1CIFjEJLw6WF1hY6kk4BAZ3K9PptvTj3pG7NY3TmrKlmI3RbMKBYIUVrKnku91mBqDxJu8oGMLWuAHdoJeSfNVxyBiqb5GjjsZ5CkOlg==",

	:login => "v9675631",
        ### TEST GATEWAY SETTINGS
        #:password => "t+IrK3EGO4nYKjfyzalmPnoLat2W9LSlz/DJdeK1iw2sHnGEE4cDGGkx9hKEnEFvGh36YsuGpe+Xi8mD5ZfGf9uhlDfOO4VxIag7XGsAh8DhyFGyff64u0aI+TtzExSGvFfPOZDJ7xx6Dp46Xtoo0Ed0vx0TYnfmpgnLyMlXCbsCIF2PRbMQxQahAuu7qWY+egtq3Zb0tKXP8Ml14rWLDawecYQThwMYaTH2EoScQW8aHfpiy4al75eLyYPll8Z/26GUN847hXEhqDtcawCHwOHIUbJ9/ri7Roj5O3MTFIa8V885kMnvHHoOnjpe2ijQR3S/HRNid+amCcvIyVcJuw==",
        #:test=> true,
        #:ignore_avs => true,  
        #:ignore_cvv => true

	:password => "RWKzJjQXET3SXPqWak4JqK4NmCovoHFKm6o4OFT1/eLUrySgdgkpQTf+NDWr8dstAXN+oo47JAit9QthxguYIRwgAMN+J0T4U9zXTydDZkqmfwrfoKlLouQZmCCs+shQGGzhU1rWL6Trdn9xsX5yQ+XQ3n5oAE0GaB+ccS9m9VTx0r8m95XFO7YINeCfKXVk+vKrL6BxSpuqODhU9f3i1K8koHYJKUE3/jQ1q/HbLQFzfqKOOyQIrfULYcYLmCEcIADDfidE+FPc108nQ2ZKpn8K36CpS6LkGZggrPrIUBhs4VNa1i+k63Z/cbF+ckPl0N5+aABNBmgfnHEvZvVU/w==",
        :test=> false,
        :ignore_avs => false,  
        :ignore_cvv => false


      )
      
      options = {
        :ip => request.remote_ip,
        :email => @billing.email,
        :address => { 
        :address1 => @billing.address,
        :address2 =>  @billing.address2,
        :city =>  @billing.city,
        :state => @billing.state,
        :zip => @billing.zip,
        :country => @billing.country,
        :phone => @billing.phone
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
    @billing = @order.person
  end
  
  protected
  def prepare_valid_order
    @order =  Order.new(params[:order])
    @order.team = @team
    @customer = current_user
    @person = @customer.person
    if params[:use_personal_address] == "1"
      @billing = Person.new(@person.attributes)
    else
      @billing = Person.new(params[:person])
    end
    #@person.attributes = (params[:person])
    @billing.validation_mode = :order
    @order.person = @billing
    @credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
    @order.credit_card = @credit_card
    if @order.valid? && @billing.valid? && @customer.valid? && @credit_card.valid?
      return true
    else
      flash.now[:notice] = "Please correct your details before you can continue"
      render :action => "index"
      return false
    end
  end
end
