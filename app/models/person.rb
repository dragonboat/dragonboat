class Person < ActiveRecord::Base
  set_table_name "persons"
  validates_presence_of :first_name, :last_name
  has_one :user, :dependent => :destroy
  has_one :volunteer, :dependent => :destroy
  has_one :orphaned_paddler, :dependent => :destroy
  validates_format_of  :email, :with => /^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$/i, :message => 'E-mail should be valid' #, :if=>Proc.new { |person| person.email&&!person.email.empty? }
 
  attr_accessor :validation_mode
  attr_reader :age
  
  def check_dependency?
   !has_associated?(self, Client, Manager, Tutor, Student, Parent)
  end
  
  def age
    d1 = self.birthday_date
    d2 = Date.today
   (d2.year - d1.year) + ((d2.month - d1.month) + ((d2.day - d1.day) < 0 ? -1 : 0) < 0 ? -1 : 0)
  end
    
  def name
    self.first_name + " " + self.last_name
  end
  
  def validate    
    if self.validation_mode == :volunteer   
      for attr_name in [:phone, :address]
        errors.add_on_blank(attr_name, 'is required')
      end
    elsif  self.validation_mode == :paddler
      for attr_name in [:phone, :birthday_date, :experience, :preference]
        errors.add_on_blank(attr_name, 'is required')
      end
    elsif  self.validation_mode == :order
      for attr_name in [:phone,:address, :zip, :city]
        errors.add_on_blank(attr_name, 'is required')
      end
    end 
  end
end
