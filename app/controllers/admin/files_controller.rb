class Admin::FilesController < ApplicationController
  require_role "admin", :if => "login_required"
  layout 'comatose_admin'
  
  def index
    session[:file_search_query] = params[:q] if params[:q]
    session[:file_search_query] = nil if params[:clear]
    conditions = nil
    if session[:file_search_query]
      @query = session[:file_search_query]
      conditions = ["filename LIKE :query OR id = :query",
                    {:query => "%#{@query}%"}]
    end
    @files = current_user.files.paginate(:all,:conditions => conditions,
                                 :page => params[:page],
                                 :per_page =>APP_CONFIG["admin_per_page"],
                                 :order => 'created_at DESC')
  end
  
  def create
     @file = DataFile.new(params[:file])
   #  @file.size = File.size()
     @file.user = User.find(current_user)
     if @file.save
       respond_to do |format|
       flash[:notice] = 'File was successfully uploaded.'
       format.html { redirect_to admin_files_path }
       end
     else
        index
        render :action=>:index
     end
  end
  
  def edit
    @file = current_user.files.find(params[:id])
  end
  
  def update
    @file = current_user.files.find(params[:id])
    if @file.update_attributes(params[:file])
    respond_to do |format|
      flash[:notice] = 'File was successfully updated.'
      format.html { redirect_to admin_file_path(@file) }
    end
    else
      format.html { render :action => "edit" }
    end
  end
  
  def show
    @file = current_user.files.find(params[:id])
  end
  
  def destroy
    @file = current_user.files.find(params[:id])
    @file.destroy
    respond_to do |format|
      format.html { redirect_to admin_files_path }
    end
  end
end
