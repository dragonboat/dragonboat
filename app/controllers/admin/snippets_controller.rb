class Admin::SnippetsController < Admin::WebsiteController 
  #Snippet
  before_filter :fetch_root_pages
     # Shows the page tree
    def index
    end
    
    # Create a new page (posts back)
    def new
      if request.post?
        @page = Comatose::Page.new params[:page]
        @page.author = current_user
        @page.is_page = false
        if @page.valid? && @page.save
          expire_cms_page @page
          expire_cms_fragment @page
          flash[:notice] = "Created snippet '#{@page.title}'"
          redirect_to :controller=>self.controller_name, :action=>'index'
        end
      else
        @page = Comatose::Page.new :title=>'New Snippet', :parent_id=>(params[:parent] || nil)
      end 
 expire_fragment( :action => "new", :action_suffix => "page")
      
    end
    
    # Edit a specfic page (posts back)
    def edit
      # Clear the page cache for this page... ?
      @page = Comatose::Page.find_is_snippet params[:id]
      if request.post?
        @page.update_attributes(params[:page])
        @page.updated_on = Time.now
        @page.author = current_user
        if @page.valid? && @page.save
          expire_cms_page @page
          expire_cms_fragment @page
          flash[:notice] = "Saved changes to '#{@page.title}'"
          redirect_to :controller=>self.controller_name, :action=>'index'
        end
        
      end
    end
    
     # Returns a preview of the page content...
    def preview
      begin
        page = Comatose::Page.new(params[:page])
        page.author = current_user
        if params.has_key? :version
          content = page.to_html( {'params'=>params.stringify_keys, 'version'=>params[:version]} )
        else
          content = page.to_html( {'params'=>params.stringify_keys} )
        end
      rescue SyntaxError
        content = "<p>There was an error generating the preview.</p><p><pre>#{$!.to_s.gsub(/\</, '&lt;')}</pre></p>"
      rescue
        content = "<p>There was an error generating the preview.</p><p><pre>#{$!.to_s.gsub(/\</, '&lt;')}</pre></p>"
      end
      render :text=>content, :layout => false
    end
    
      # Allows comparing between two versions of a page's content
    def versions
      @page = Comatose::Page.find_is_snippet params[:id]
      @version_num = (params[:version] || @page.versions.length).to_i
      @version = @page.find_version(@version_num)
    end
  
    # Reverts a page to a specific version...
    def set_version
      if request.post?
        @page = Comatose::Page.find_is_snippet params[:id]
        @version_num = params[:version]
        @page.revert_to!(@version_num)
      end
      redirect_to :controller=>self.controller_name, :action=>'index'
    end
  
    # Deletes the specified page
    def delete
      @page = Comatose::Page.find_is_snippet params[:id]
      if request.post?
        expire_cms_pages_from_bottom @page
        expire_cms_fragments_from_bottom @page
        @page.destroy
        flash[:notice] = "Deleted snippet '#{@page.title}'"
        redirect_to :controller=>self.controller_name, :action=>'index'
      end
    end
    
     # Expires the entire page cache
    def expire_page_cache
      expire_cms_pages_from_bottom( Comatose::Page.root)
      expire_cms_fragments_from_bottom( Comatose::Page.root )
      flash[:notice] = "Page cache has been flushed"
      redirect_to :controller=>self.controller_name, :action=>'index'
    end

private
    def fetch_root_pages
      @root_pages = Comatose::Page.find(:all, :conditions=>"is_page = 0")
    end
    
     # Calls the class methods of the same name...
    def expire_cms_page(page)
      self.class.expire_cms_page(page)
    end
    def expire_cms_pages_from_bottom(page)
      self.class.expire_cms_pages_from_bottom(page)
    end
    
  
    # expire the page from the fragment cache
    def expire_cms_fragment(page)
      key = page.full_path.gsub(/\//, '+')
      expire_fragment(key)
    end
  
    # expire pages starting at a specific node
    def expire_cms_fragments_from_bottom(page)
      pages = page.is_a?(Array) ? page : [page] 
      pages.each do |page|
        page.children.each {|c| expire_cms_fragments_from_bottom( c ) } if !page.children.empty?
        expire_cms_fragment( page )
      end
    end
  
    # Class Methods...
    class << self

      # Walks all the way down, and back up the tree -- the allows the expire_cms_page
      # to delete empty directories better
      def expire_cms_pages_from_bottom(page)
        pages = page.is_a?(Array) ? page : [page] 
        pages.each do |page|
          page.children.each {|c| expire_cms_pages_from_bottom( c ) } if !page.children.empty?
          expire_cms_page( page )
        end
      end

      # Expire the page from all the mount points...
      def expire_cms_page(page)
        Comatose.mount_points.each do |path_info|
          Comatose::Page.active_mount_info = path_info
          expire_page(page.uri)
          # If the page is the index page for the root, expire it too
          if path_info[:root] == page.uri
            expire_page("#{path_info[:root]}/index")
          end
          begin # I'm not sure this matters too much -- but it keeps things clean
            dir_path = File.join(RAILS_ROOT, 'public', page.uri[1..-1])
            Dir.delete( dir_path ) if FileTest.directory?( dir_path ) and !page.parent.nil?
          rescue
            # It probably isn't empty -- just as well we leave it be
            #STDERR.puts " - Couldn't delete dir #{dir_path} -> #{$!}"
          end 
        end
      end
    end
end
