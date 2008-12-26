class SupportController < ApplicationController
  include SupportHelper
  layout "application"
  def index
    new
    render :action=>"new"
  end
  
  def new
    @ticket = Ticket.new
    define_user
  end
  
  def create
    @ticket = Ticket.new(params[:ticket])
    unless params[:user] && params[:user][:login]
      define_user
    else 
      @user = User.find_by_login(params[:user][:login])  
      @ticket.email = @user.email if @user
      @ticket.user_id = @user.id  if @user
      @ticket.updated_by = @user  if @user
    end
    if @ticket.save
      redirect_to new_support_path
      flash[:notice] = "Your ticket was successfully created"
    else
      render :action => 'new'
    end 
  end
  
  def show
    begin
      @ticket = Ticket.find_nonregistered(params[:id])
      rescue Exception 
    end  
  end
  
  def email_by_login
    @ticket = Ticket.find_or_initialize_by_id(params[:id])
    if params[:login]
      @user = User.find_by_login(params[:login]) 
      
      @ticket.user_id = @user.id if @user
      @ticket.email = @user.email if @user
    end
    render :update do |page|
      page.replace_html :ticket_email_box, :partial => 'email'
    end
  end
  
 def reply
  #params[:answer_id]  - answer id
  #params[:id] - ticket id
  @parent = Ticket.find_nonregistered(params[:id])
  @ticket = Ticket.new
  @ticket.parent_id = @parent.id
  @ticket.email = @parent.email
  @ticket.user = @parent.user
  @ticket.updated_by = @parent.user
   
  @answer = @parent.answers.find(params[:answer_id])
  @ticket.subject, @ticket.message = reply_to(@parent, @answer)
  if request.post?
    @ticket.attributes=(params[:ticket])
    if @ticket.save
      flash[:notice] = "Reply ticket was successfully created"
      redirect_to :action=>:show, :id=>@ticket.id
      return
    end
  end
end
  
  private
  def define_user
    if current_user
      @ticket.user_id = current_user.id 
      @ticket.email = current_user.email
      @ticket.updated_by = current_user
      @user = @ticket.user
    end
  end
end