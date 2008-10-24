class OrphanedPaddler < ActiveRecord::Base
  belongs_to :person
  validates_associated :person
 
  def after_initialize
    build_person unless person
  end
  
  def after_destroy
    person.destroy
  end
end
