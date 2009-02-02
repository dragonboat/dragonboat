#Purchased Practices for team
class TeamPractice < ActiveRecord::Base
  belongs_to :team
  validates_associated :team
end
