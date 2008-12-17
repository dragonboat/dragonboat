class Admin::SupportController < Admin::WebsiteController
  def index
    order = case params[:sort]
      when 'ticket_id'             then 'tickets.id'
      when 'ticket_id_reverse'      then 'tickets.id desc'
      when 'ticket_subject'             then 'tickets.subject'
      when 'ticket_subject_reverse'      then 'tickets.subject desc'
      when 'ticket_email'             then 'tickets.email'
      when 'ticket_email_reverse'      then 'tickets.email desc'
      when 'ticket_user'             then 'users.login'
      when 'ticket_user_reverse'      then 'users.login desc'
      when 'ticket_priority'             then 'tickets.priority'
      when 'ticket_priority_reverse'      then 'tickets.priority desc'
      when 'ticket_status'             then 'tickets.status'
      when 'ticket_status_reverse'      then 'tickets.status desc' 
      when 'ticket_created_at'                then 'tickets.created_at'
      when 'ticket_created_at_reverse'        then 'tickets.created_at desc'
      else 'tickets.created_at DESC'
    end
    @tickets = Ticket.paginate( :page => params[:page], 
                              :include=>[:user],
                              :per_page =>APP_CONFIG["admin_per_page"],
                              :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def show
    @ticket = Ticket.find(params[:id])
  end
  
  def edit
    @ticket = Ticket.find(params[:id])
    @user = @ticket.user
    @answer = @ticket.answers.build
  end
  
  def update
    @ticket = Ticket.find(params[:id])
    @ticket.attributes = (params[:ticket])
    @user = @ticket.user
    @answer = @ticket.answers.build
    @answer.attributes = (params[:answer])
      
    respond_to do |format|
      if @ticket.valid? && @answer.valid? && @answer.save && @ticket.save
        flash[:notice] = 'Support Ticket was successfully updated. Reply was successfully sent.'
        format.html { redirect_to admin_support_ticket_url(@ticket.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

end
