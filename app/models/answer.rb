class Answer < ActiveRecord::Base
  belongs_to :ticket, :foreign_key => 'ticket_id', :class_name=>"Ticket"
end
