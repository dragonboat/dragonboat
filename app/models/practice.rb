class Practice < ActiveRecord::Base
#  has_enumerated  :status, :class_name => 'Status',:foreign_key => 'status_id'
#  belongs_to :status
# *
# Practice Status is available if team_id is NULL
# Practice Status is reserved  if team_id is not NULL
# *
  validates_presence_of :created_at
  validates_uniqueness_of :created_at
  belongs_to :team
  
  HUMANIZED_ATTRIBUTES = {
    :created_at => "Practice Date"
  }
  scope_out :available,
            :conditions => "team_id IS NULL"
  scope_out :reserved,
            :conditions => "team_id IS NOT NULL"
          
  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
  def after_initialize
    self.created_at = Time.local(2009,7,1,8,0) unless self.created_at 
  end
  
  def self.total(current_date=Date.today)
    Practice.find(:all, :conditions=>"CAST(created_at AS DATE) = '#{current_date.to_date.to_s(:db)}'").size
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
  
  def status
   team_id.nil? ? "available" : "reserved"
  end
  
  def team_name
    team.nil? ? "available" : team.name
  end
end
