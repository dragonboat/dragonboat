class Practice < ActiveRecord::Base
  has_enumerated  :status, :class_name => 'Status',:foreign_key => 'status_id'
  belongs_to :status
  validates_presence_of :name, :created_at, :description
end
