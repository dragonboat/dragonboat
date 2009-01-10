class Practice < ActiveRecord::Base
#  has_enumerated  :status, :class_name => 'Status',:foreign_key => 'status_id'
#  belongs_to :status
# *
# Practice Status is available if team_id is NULL
# Practice Status is reserved  if team_id is not NULL
# *
  validates_presence_of :created_at
#  validates_uniqueness_of :created_at
  belongs_to :team
  
  HUMANIZED_ATTRIBUTES = {
    :created_at => "Practice Date"
  }
  scope_out :available,
            :conditions => "team_id IS NULL"
  scope_out :reserved,
            :conditions => "team_id IS NOT NULL"
  
  attr_accessor :validation_mode
          
  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def after_initialize
    self.created_at = Time.local(2009,7,1,8,0) unless self.created_at 
  end
  
  def validate    
    if self.validation_mode == :team   
      total_per_month = team.practices.total_per_month(created_at)
      if total_per_month > 0
        errors.add(:created_at, 'You cannot reserve more than one practice per month. To change the date and time of your practice, first select the one you have and cancel it, and then you may reserve any other open practice time')
      end
    end 
  end
  
  def self.total(current_date=Date.today)
    Practice.find(:all, :conditions=>"CAST(created_at AS DATE) = '#{current_date.to_date.to_s(:db)}'").size
  end
  
  def self.total_per_month(current_date=Date.today)
    self.find(:all, :conditions=>"DATE_FORMAT(created_at,'%m-%Y') = '#{current_date.strftime('%m-%Y')}'").size
  end
  
  #week_num this is a number from 0 till 6 starting on Sunday
  def self.find_by_week(week_num=0)
    self.find(:all, :conditions=>"DATE_FORMAT(created_at,'%w')= '#{week_num.to_i}'",
      :order => "created_at DESC" )
  end
  
  #month_num this is a number from 0 till 12
  def self.find_by_month(month_num=0)
    self.find(:all, :conditions=>"DATE_FORMAT(created_at,'%c')= '#{month_num.to_i}'",
      :order => "created_at DESC" )
  end
  
  
  def self.find_by_day(current_date) 
     Practice.find(:all, :conditions=>"CAST(created_at AS DATE) = '#{current_date.to_date.to_s(:db)}'")
  end
  
  def self.total_available(current_date=Date.today)
    Practice.find_available(:all, :conditions=>"CAST(created_at AS DATE) = '#{current_date.to_date.to_s(:db)}'").size  
  end
  
  def self.total_reserved(current_date=Date.today)
    Practice.find_reserved(:all, :conditions=>"CAST(created_at AS DATE) = '#{current_date.to_date.to_s(:db)}'").size  
  end
  
  def self.is_full?(current_date=Date.today)
    Practice.total(current_date) == Practice.total_reserved(current_date)
  end
  
  def time
    created_at.strftime("%I:%M%p")
  end
  
  def date
    created_at.strftime("%d %B %Y")
  end
  
  def status
   team_id.nil? ? "available" : "reserved"
  end
  
  def team_name
    team.nil? ? "available" : team.name
  end
  
  
end
