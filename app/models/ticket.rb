class Ticket < ActiveRecord::Base
  PRIORITY = [["Low","low"], ["Medium","medium"], ["High","high"]]
  STATUS = [["Open","open"], ["Pending","pending"], ["Review","review"], ["Closed","closed"]]
  validates_presence_of :message, :subject
  validates_format_of  :email, :with => /^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$/i, :message => 'E-mail should be valid'
  validates_inclusion_of :priority, :in=>%w( low medium high )
  validates_inclusion_of :status, :in=>%w( open pending review closed )
  
  belongs_to :user, :foreign_key => 'user_id', :class_name=>"User"
  acts_as_tree :order => :created_at
  
  has_many :answers, :dependent=>:destroy
  
  def after_initialize
    self.status = 'open' unless self.status
  end
end
