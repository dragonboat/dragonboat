# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # TODO: Move the click to edit extension to ajax_form_helper.js and split this into two methods
  # with in_place_collection_editor_field_editor.
  # See http://api.rubyonrails.org/classes/ActionView/Helpers/JavaScriptMacrosHelper.html#M000461
  def in_place_collection_editor_field(object, method, collection_array, tag_options={}, in_place_collection_editor_options={},update={})
    collection = collection_array.dup
    if in_place_collection_editor_options.delete(:include_blank)
      collection.unshift(['',''])
    end
    tag = ::ActionView::Helpers::InstanceTag.new(object, method, self)
    match = collection.inject('') do |memo, element|
      if !element.is_a?(String) and element.respond_to?(:first) and element.respond_to?(:last)
        element.last.to_s == tag.value(tag.object).to_s ? element.first : memo
      else
        element.to_s == tag.value(tag.object).to_s ? element.to_s : memo
      end
    end

    unless match.blank?
      content, tag_class = [match, "in_place_editor_field"]      
    else
      content, tag_class = ['нажмите для редактирования...', 'inplaceeditor-empty']
    end
    tag_options = {:tag => "span", :id => "#{object}_#{method}_#{tag.object.id}_in_place_collection_editor", 
      :class => tag_class}.merge!(tag_options)
    url = url_for( {:action => "set_#{object}_#{method}", :id => tag.object.id}.merge(update) )
    function =  "new Ajax.InPlaceCollectionEditor(" 
    function << "'#{object}_#{method}_#{tag.object.id}_in_place_collection_editor'," 
    function << "'#{url}',"
    js_collection = collection.inject([]) do |options, element|
       if !element.is_a?(String) and element.respond_to?(:first) and element.respond_to?(:last)
        options << "[ '#{html_escape(escape_javascript(element.last.to_s))}', '#{escape_javascript(element.first.to_s)}']"
      else
        options << "[ '#{html_escape(escape_javascript(element.to_s))}', '#{escape_javascript(element.to_s)}']"        
      end
    end
    function << "{collection: [#{js_collection.join(',')}],"
    function << "value: '#{tag.value(tag.object)}'" unless tag.value(tag.object).blank?
    function << "});" 
    content_tag(tag_options.delete(:tag), content, tag_options) + javascript_tag(function)
  end
  
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
   
   def pre_festival_times( options = nil, text_format = false)
     html = []
     from_time = Time.now.beginning_of_day 
     to_time =   Time.now.end_of_day  
     Date::DAYNAMES.each_with_index do |d,i|
       d = d.downcase
       if options
         option = options.map(&:option)
         from_ts = options.map(&:from)
         to_ts = options.map(&:to)
         index = option.index(d)  
       end 
       from = index ? from_ts[index] : from_time
       to = index ? to_ts[index] : to_time
       unless text_format
        from = select_hour(from,:field_name=>"from_hour", :prefix=>"#{d}" ) 
        to = select_hour(to,:field_name => "to_hour", :prefix=>"#{d}")
       else
        from = from.strftime("%H")
        to = to.strftime("%H")
       end
       html << {:name=>", from #{from} to #{to} (hours)", :id=>"#{d}"}
     end
     html
   end
   
   # Public Navigation  
   def navigation_links(current_page_slug = '', separator = " &raquo; ")   
     page = Comatose::Page.find_by_path( current_page_slug ) if !current_page_slug.nil? && !current_page_slug.empty?
     if page && page.is_page==true
       pages_paths = page.ancestors.map(&:full_path).select {|p| p}
       current_page = {:title=>page.title.titleize, :uri=>page.uri}
     else
       #current_page = {:title=>"Home", :uri=>"/"}
     end
     pages_paths = [] unless pages_paths
     html = ""
      pages_paths.map { |path| Comatose::Page.find_by_path(path) }.reverse.each do |page|     
        html << link_to(page.title.titleize, page.uri)
        html << separator
      end 
      html << link_to(current_page[:title], current_page[:uri]) if current_page
   end
   
   def navigation_path(current_page_slug = '', separator = " &raquo; ")   
     page = Comatose::Page.find_by_path( current_page_slug ) if !current_page_slug.nil? && !current_page_slug.empty?
     if page && page.is_page==true
       pages_paths = page.ancestors.map(&:full_path).select {|p| p}
       current_page = {:title=>page.title.titleize, :uri=>page.uri}
     end
     pages_paths = [] unless pages_paths
     html = ""
     #
     # pages_paths.map { |path| Comatose::Page.find_by_path(path) }.reverse.each do |page| 
     #   next if page.root == page
     #   html << page.title.titleize
    #    html << separator
     # end 
      html << current_page[:title] if current_page
   end

   def address(person)
     "#{person.address} #{person.address2} #{person.city}, #{person.state} #{person.zip} #{person.country}"
   end
   
   def is_free_registration
     session[:free] && session[:free]=="1" && [0].include?(current_user.teams.size)
   end
end