require 'ostruct'

class EventFilter
  attr_accessor :start_date, :end_date, :date_range
  
  def initialize(start_date = Time.now, end_date = Time.now)
    @start_date, @end_date = start_date, end_date
  end
  
  # Returns a conditions array suitable for ActiveRecord::Base.find
  def to_conditions(params={})
    # Create an object to store named parameter conditions
    conditioner = OpenStruct.new
    conditioner.or = []
    conditioner.and = []
    conditioner.parameters = {}
    
    if @start_date && @end_date
      conditioner.and << " CAST(start_date AS DATE) >= :start_date AND CAST(start_date AS DATE) <= :end_date"
      conditioner.parameters[:start_date] = @start_date.to_s(:db)
      conditioner.parameters[:end_date] = @end_date.to_s(:db)
    end
    statement = conditioner.or.join(' OR ')
    statement += " AND " if !conditioner.or.empty? and !conditioner.and.empty?
    statement += conditioner.and.join(' AND ')
    return [statement, conditioner.parameters]
  end
  
 
  
end