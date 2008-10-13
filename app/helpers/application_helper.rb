# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sort_link_for( txt, parm )
    txt==parm ? "#{txt}_reverse" : txt
  end
  
end
