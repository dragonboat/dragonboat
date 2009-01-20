require 'digest/sha1'
class User < ActiveRecord::Base
  ROLE = ["standard","captain","admin"]
  # Virtual attribute for the unencrypted password
  attr_accessor :password 
  attr_accessor :validation_mode

  validates_presence_of     :login
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required? && Proc.new { |user| user.password&&!user.password.empty? }
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :minimum=>3, :if => :login?
  #validates_format_of       :email, :with => /^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$/i, :message => 'E-mail should be valid'
  validates_uniqueness_of   :login, :case_sensitive => false #:email
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :role
  # ---------------------------------------
  # The following code has been generated by role_requirement.
  # You may wish to modify it to suit your need
  has_and_belongs_to_many :roles
  
 
  has_many :images, :foreign_key => 'created_by'
  has_many :files, :foreign_key => 'created_by', :class_name=>"DataFile"
  has_many :news, :foreign_key => 'created_by', :class_name=>"News"
  has_many :tickets, :dependent=>:destroy
  
  has_one :member, :dependent=>:destroy
 
  has_many :teams, :foreign_key => 'captain_id', :class_name=>"Team",:dependent=>:destroy
  has_many :orders, :dependent=>:destroy

  has_many :active_teams, :foreign_key => 'captain_id', :class_name=>"Team",:dependent=>:destroy,
    :conditions => "status_id=#{Status.find_team_by_name('active').id}"
  has_many :inactive_teams, :foreign_key => 'captain_id', :class_name=>"Team",:dependent=>:destroy,
    :conditions => "status_id=#{Status.find_team_by_name('inactive').id}"
  
  belongs_to :person
  validates_associated :person
  
  
   HUMANIZED_ATTRIBUTES = {
    :login => "The username"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
    
  def after_initialize
    build_person unless person
  end
  
  def after_create
    roles << Role.find_by_name("standard") unless is_standard?
    if role == "admin"
      roles << Role.find_by_name("admin") unless is_admin?
    elsif role == "captain"
      roles << Role.find_by_name("captain") unless is_captain?
    end
  end
  
  def after_destroy
    person.destroy
  end
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end
  # ---------------------------------------
  
  def is_admin?
    has_role?("admin")
  end
  
  def is_captain?
    has_role?("captain")
  end
  
  def is_standard?
    has_role?("standard") && !is_captain? && !is_admin?
  end
  
  def is_member?
    !member.nil?
  end
  
  def has_any_boat?
    if is_member?&&member.user.is_captain? 
      return false
    end  
    !is_member?&&active_teams.count < 1
  end
  
  def has_any_inactive_boat?
    inactive_teams.count > 0
  end 
  
  def type
    role.capitalize
  end
  
  def role
   return read_attribute(:role) if !read_attribute(:role).blank?
   return "admin" if is_admin?
   return "captain" if is_captain? 
   return "standard"
  end
  
  def role=(str)
    write_attribute(:role,str)
  end
  
  def to_captain
    unless is_captain?
      roles << Role.find_by_name("captain") 
    end
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def self.find_by_code(url_code)
    User.find(:all).each do |u|
      return u if u.has_code?(url_code) && u.is_member?
      break if u.has_code?(url_code)
    end
    nil
  end
  
  def self.find_all_by_code(url_code)
    User.find(:all).each do |u|
      return u if u.has_code?(url_code)
    end
    nil
  end
  
  def has_code?(url_code)
    url_code == code
  end
  
  def code
    encrypt(self.login)
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def password_reset!
    new_password = self.class.random_string(10)
    self.password = self.password_confirmation = new_password
    self.valid?
    puts self.errors.to_xml
    self.save ? new_password : nil    
  end
  
  def email
    person.email
  end
  
  def generate_account(prefix_name="")
    self.login = "#{person.first_name}.#{person.last_name}".downcase
    users = User.find(:all, :conditions=>["login LIKE ?","%#{self.login}%"], :order=>"login")
    logins = users.map(&:login).select {|l| (l =~/[.][\d]{1,}$/i) != nil }
    if logins.size > 0
      numbers = []
      logins.map do |login|
        login =~ /[.]([\d]{1,})$/i
        numbers << $1.to_i
      end
      last_login_number = numbers.sort{|x,y| y <=> x }.first
      self.login+=".#{last_login_number+1}" if last_login_number
    elsif users.map(&:login).select {|l| l =~/#{self.login}$/i }.size > 0
      self.login+=".1" 
    end
    new_password = self.class.random_string(10)
    self.password = new_password
    self.password_confirmation = new_password
  end
  
  def validate    
    if  self.validation_mode  == :member
      illegal_character = login.gsub(/[^A-Z0-9_ ]/i, "")
      errors.add(:login, 'you provided was not valid. Please ensure that there are no special characters in the name') if login != illegal_character
    end 
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def self.random_string(len) 
      #generate  a  random  password  consisting  of  strings  and  digits 
      chars  =  ("a".."z").to_a  +  ("A".."Z").to_a  +  ("0".."9").to_a 
      newpass  =  "" 
      1.upto(len)  {  |i|  newpass  <<  chars[rand(chars.size-1)]  } 
      return  newpass 
    end
    
    def login?
      !login.blank?
    end
    
    
end
