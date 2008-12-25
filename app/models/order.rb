class Order < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :person, :foreign_key => 'billing_id', :class_name=>"Person"
  
  has_many :extras_orders, :dependent=>:destroy
  # =============
  # = Constants =
  # =============

  CARD_TYPES = [ ['Visa',:visa], ['MasterCard',:master], ['American Express',:american_express], ['Discover', :discover]]
  # ===============
  # = Secure attr =
  # ===============
  attr_protected :customer_ip, :gateway_message, :boat_pay, :total_pay, :credit_card
  serialize :credit_card, ActiveMerchant::Billing::CreditCard
  
  
  validates_uniqueness_of :team_id, :scope => [:team_id, :status], :if => :allow_validation

  validates_associated :team, :user
  
  validates_inclusion_of  :status, :in => %w(open processed prepared canceled failed)
  
  def after_initialize
    self.status = 'open' unless self.status
  end
  
  def after_destroy
    person.destroy
  end
  
  def allow_validation
    self.status == 'processed'
  end
  
  def calculate_boat_pay
    team.price
  end
  
  def extras_pay
    s = 0
    extras_orders.each {|e| s+=e.pay}
    return s
  end
    
  def calculate_total_pay
    calculate_boat_pay + extras_pay
  end
  
  def process
    team.team_extras.each { |item| populate_item(item) }
    self.status = "processed"
    self.boat_pay = calculate_boat_pay
    self.total_pay = team.total
    self.save!
  end
  
  def activate
    return false unless  self.valid?
    user.to_captain
    team.activate
    #empty cart
    team.team_extras.each(&:destroy) if !@team.team_extras.empty?
    OrderNotifier.send("deliver_processed", self)
    true
  end
  
  def failed!
  #  team.team_extras.each { |item| populate_item(item) }
    self.status = 'failed'
    self.save!
  end
  
  def boat_pay
    read_attribute(:boat_pay).to_f/100
  end
  
  def boat_pay=(pay)
    write_attribute(:boat_pay, pay*100)
  end
  
  def total_pay
    read_attribute(:total_pay).to_f/100
  end
  
  def total_pay=(pay)
    write_attribute(:total_pay, pay*100)
  end
  
  private
  def populate_item(item)
   extras = item.extras 
   extras_orders << ExtrasOrder.create({
                                        :extras_id => extras.id,
                                        :extras_type => "#{extras.name}" + extras.description ,
                                        :pay => extras.price,
                                        :quantity  =>item.quantity
                                      })
   if extras.name =~ /tent/i 
     team.create_tent unless team.tent
   end
  end
end
