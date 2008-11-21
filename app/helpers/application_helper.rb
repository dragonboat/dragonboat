# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sort_link_for( txt, parm )
    txt==parm ? "#{txt}_reverse" : txt
  end
  
  def previous_link_for_year(date)
    html = ""
    html =  link_to_remote(" &laquo; " + date.strftime("%Y"), 
      :url=>{:action=>:update_calendar, :mon => date.mon, :year=> date.year},
      :title=>"Previous Year")
  end
  
  def previous_link_for_month(date)
    html = ""
    html =  link_to_remote(" &laquo; "+date.strftime("%B"), 
      :url=>{:action=>:update_calendar, :mon => date.mon, :year=> date.year},
      :title=>"Previous Month")
  end
  
  def next_link_for_year(date)
    html = ""
    html =  link_to_remote(date.strftime("%Y") + " &raquo; ", 
      :url=>{:action=>:update_calendar, :mon => date.mon, :year=> date.year},
      :title=>"Next Year")
  end
  
  def next_link_for_month(date)
    html = ""
    html =  link_to_remote(date.strftime("%B") + " &raquo; ", 
      :url=>{:action=>:update_calendar, :mon => date.mon, :year=> date.year},
      :title=>"Next Month")
  end
  
  def states_options
    [ 	
    	['Select a State', nil],
    	['Alabama', 'AL'], 
    	['Alaska', 'AK'],
    	['Arizona', 'AZ'],
    	['Arkansas', 'AR'], 
    	['California', 'CA'], 
    	['Colorado', 'CO'], 
    	['Connecticut', 'CT'], 
    	['Delaware', 'DE'], 
    	['District Of Columbia', 'DC'], 
    	['Florida', 'FL'],
    	['Georgia', 'GA'],
    	['Hawaii', 'HI'], 
    	['Idaho', 'ID'], 
    	['Illinois', 'IL'], 
    	['Indiana', 'IN'], 
    	['Iowa', 'IA'], 
    	['Kansas', 'KS'], 
    	['Kentucky', 'KY'], 
    	['Louisiana', 'LA'], 
    	['Maine', 'ME'], 
    	['Maryland', 'MD'], 
    	['Massachusetts', 'MA'], 
    	['Michigan', 'MI'], 
    	['Minnesota', 'MN'],
    	['Mississippi', 'MS'], 
    	['Missouri', 'MO'], 
    	['Montana', 'MT'], 
    	['Nebraska', 'NE'], 
    	['Nevada', 'NV'], 
    	['New Hampshire', 'NH'], 
    	['New Jersey', 'NJ'], 
    	['New Mexico', 'NM'], 
    	['New York', 'NY'], 
    	['North Carolina', 'NC'], 
    	['North Dakota', 'ND'], 
    	['Ohio', 'OH'], 
    	['Oklahoma', 'OK'], 
    	['Oregon', 'OR'], 
    	['Pennsylvania', 'PA'], 
    	['Rhode Island', 'RI'], 
    	['South Carolina', 'SC'], 
    	['South Dakota', 'SD'], 
    	['Tennessee', 'TN'], 
    	['Texas', 'TX'], 
    	['Utah', 'UT'], 
    	['Vermont', 'VT'], 
    	['Virginia', 'VA'], 
    	['Washington', 'WA'], 
    	['West Virginia', 'WV'], 
    	['Wisconsin', 'WI'], 
    	['Wyoming', 'WY']]
   end
   
   def invitation_status_id_by_name(name)
     status = Status.find_invitation_by_name(name)
     return  status ? status.id : nil
   end
end