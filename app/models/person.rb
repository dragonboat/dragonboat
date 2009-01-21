class Person < ActiveRecord::Base
  set_table_name "persons"
  validates_presence_of :first_name, :last_name
  has_one :user #, :dependent => :destroy
  has_one :volunteer #, :dependent => :destroy
  has_one :orphaned_paddler #, :dependent => :destroy
  validates_format_of  :email, :with => /^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$/i, :message => 'should be valid' #, :if=>Proc.new { |person| person.email&&!person.email.empty? }
  
 
  attr_accessor :validation_mode
  attr_reader :age
  
  HUMANIZED_ATTRIBUTES = {
    :phone => "Home Phone number",
    :address => "Street Address 1",
    :zip => "Zip code"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def before_validation
    self.first_name = self.first_name.strip 
    self.last_name = self.last_name.strip
    self.email = self.email.strip
  end
  
  def age
    return "" unless birthday_date
    d1 = self.birthday_date
    d2 = Date.today
   (d2.year - d1.year) + ((d2.month - d1.month) + ((d2.day - d1.day) < 0 ? -1 : 0) < 0 ? -1 : 0)
  end
    
  def name
    self.first_name.to_s + " " + self.last_name.to_s
  end
  
  def human_birthday_date
    birthday_date ? birthday_date.strftime("%d/%m/%Y") : ""  
  end
  
  def gender_f=(f)
    self.gender = f
  end
  
  def gender_m=(m)
    self.gender = m
  end
  
  def gender_f
    self.gender
  end
  
  def gender_m
    self.gender
  end
  
  def validate    
    phone_number = phone.gsub(/[^0-9]/, "") if phone
    if self.validation_mode == :volunteer   
      for attr_name in [:phone, :address]
        errors.add_on_blank(attr_name, 'is required')
      end
      errors.add(:phone, 'must consist of 10 digits') if  phone_number.size != 10 
    elsif  self.validation_mode  == :member 
      for attr_name in [:gender]
        errors.add_on_blank(attr_name, 'is required')
      end
    elsif  self.validation_mode  == :sign_waiver
      for attr_name in [:birthday_date, :zip, :address, :city, :state, :phone, :emergency_contact_name,:emergency_contact_number]
        errors.add_on_blank(attr_name, 'is required')
      end
      if zip && !zip.empty?
        errors.add(:zip, 'is not valid') unless zip =~ /^[ A-Z\d]{0,9}$/i
      end
    elsif  self.validation_mode == :paddler
      for attr_name in [:gender, :phone, :birthday_date]
        errors.add_on_blank(attr_name, 'is required')
      end
      errors.add(:phone, 'must consist of 10 digits') if  phone_number.size != 10 
    elsif  self.validation_mode == :order
      for attr_name in [:phone,:address, :zip, :city, :state, :country]
        errors.add_on_blank(attr_name, 'is required')
      end
      errors.add(:phone, 'must consist of 10 digits') if  phone_number&&phone_number.size != 10 
      errors.add(:zip, 'is not valid') unless zip =~ /^[ A-Z\d]{0,9}$/i
    end 
  end
end
