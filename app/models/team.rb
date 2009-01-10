class Team < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  validates_presence_of :name
  belongs_to :boat_type, :foreign_key => 'type_id', :class_name=>"BoatType"
  belongs_to :captain, :foreign_key => 'captain_id', :class_name=>"User"
  belongs_to :image, :foreign_key => 'logo_id', :class_name=>"Image"
 
  has_many :practices, :dependent=>:destroy
  has_many :team_extras, :dependent=>:destroy, :foreign_key => 'team_id', :class_name=>"TeamExtras"
 # has_many :extras, :as=>:"items", :through=>:team_extras, :foreign_key => 'team_id', :class_name=>"TeamExtras"
  
  has_many :members, :dependent=>:destroy
  has_many :users, :through => :members
  has_many :tents, :dependent=>:destroy
  
  has_one :order, :dependent=>:destroy
 
  has_enumerated  :status, :class_name => 'Status',:foreign_key => 'status_id'
  
  belongs_to :status
  validates_associated :captain
  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of  :url, :with =>/(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix

  scope_out :active,
            :conditions => "status_id=#{Status.find_team_by_name('active').id}"
          
  def before_validation
    self.human_name = self.human_name.strip 
    self.name = strip_tags(self.human_name)
    self.name = self.name.strip.gsub(/&nbsp;/i,'')
    self.description = self.description.strip 
  end
  
  def total
    total = self.price
    team_extras.each {|te| total+= te.extras.price*te.quantity}
    return total
  end

  def price
    boat_type.price
  end
  
  def activate
    set_status('active')
  end
  
  def unactivate
    set_status('inactive')
  end
  
  def status_human_name
    status.name == 'inactive' ? 'inactive (unpaid)' : 'active (paid)' if status
  end
  
  def url
    read_attribute(:url).nil? ? "" : read_attribute(:url)
  end
  
  def boat_type_human
    boat_type ? boat_type.name : ""
  end
  
  private
  def set_status(name)
    update_attribute(:status_id, Status.find_team_by_name(name).id)
  end
end
