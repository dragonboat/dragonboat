class Event < ActiveRecord::Base
  acts_as_taggable
  validates_presence_of :name, :start_date, :content

end
