class Team < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :captain, :foreign_key => 'captain_id', :class_name=>"User"
  belongs_to :image, :foreign_key => 'logo_id', :class_name=>"Image"
  has_many :members, :dependent=>:destroy
  has_one :tent, :dependent=>:destroy
  
  has_one :order, :dependent=>:destroy
 
  has_enumerated  :status, :class_name => 'Status',:foreign_key => 'status_id'
  
  validates_associated :captain
  validates_uniqueness_of :name, :case_sensitive => false
  
  scope_out :active,
            :conditions => "status_id=#{Status.find_team_by_name('active').id}"
          
  def total
    total = self.price
    total+= tent.price if tent
    return total
  end

  def price
    APP_CONFIG['boat_price']
  end
  
  def activate
    set_status('active')
  end
  
  def unactivate
    set_status('unactive')
  end
  
  private
  def set_status(name)
    update_attribute(:status_id, Status.find_team_by_name(name).id)
  end
end
