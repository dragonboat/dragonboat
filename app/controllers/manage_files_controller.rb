class ManageFilesController < ApplicationController
  require_role "admin", :if => "login_required"
  def index
    @files= current_user.files    
    render :update do |page|
      page.replace_html :dynamic_files_list, :partial => 'show_file_list', :locals => { :files => @files }
    end
  end
end
