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
end