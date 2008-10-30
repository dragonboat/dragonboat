class Admin::VolunteersController < Admin::WebsiteController
 before_filter :set_statuses, :only=>[:edit, :update, :send_message_by_type]
 def index
    order = case params[:sort]
      when 'name'             then 'first_name, last_name'
      when 'name_reverse'      then 'first_name desc, last_name desc'
      when 'email'             then 'email'
      when 'email_reverse'      then 'email desc'
      when 'status'             then 'statuses.name'
      when 'status_reverse'      then 'statuses.name desc'
      when 'applied_at'   then 'date_applied'
      when 'applied_at_reverse'   then 'date_applied DESC'
      else 'date_applied DESC'
    end
    @volunteers = Volunteer.paginate(:page => params[:page], :include=>[:person,:status],
                                :per_page =>APP_CONFIG["admin_per_page"],
                                :order => order)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @volunteers}
    end
  end

  def edit
    @volunteer = Volunteer.find(params[:id]) 
  end
  
  def update
    @volunteer = Volunteer.find(params[:id]) 
    @volunteer.attributes = (params[:volunteer])
    @volunteer.person.attributes = (params[:person])
    @volunteer.person.validation_mode = :volunteer
    respond_to do |format|
      if @volunteer.valid? && @volunteer.save &&  @volunteer.person.save
        flash[:notice] = 'Volunteer was successfully updated.'
        format.html { redirect_to admin_volunteers_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @volunteer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @volunteer = Volunteer.find(params[:id]) 
  end
  
  def destroy
    @volunteer = Volunteer.find(params[:id])
    @volunteer.destroy

    respond_to do |format|
      format.html { redirect_to(admin_volunteers_url) }
      format.xml  { head :ok }
    end
  end
  
  def send_message
    @errors = []
    @volunteer = Volunteer.find(params[:id]) 
    if request.post?  
      @subject = params[:email][:subject].to_s
      @message = params[:email][:message].to_s
      if (@subject.blank? || @message.blank?)
        @errors << "Subject is required" if @subject.blank?
        @errors << "Message is required" if @message.blank?
      elsif VolunteerNotifier.deliver_message(@volunteer, @subject, @message )
        flash[:notice] = "Message was successfully sent to #{@volunteer.person.email}."
        redirect_to admin_volunteers_url
      end
    end
  end
  
   def send_message_by_type
     @errors = []
     @emails = [] 
     if request.post?  
      @subject = params[:email][:subject].to_s
      @message = params[:email][:message].to_s
      @type_id = params[:type_id].to_i if params[:type_id].to_i > 0
      if (@subject.blank? || @message.blank?)
        @errors << "Subject is required" if @subject.blank?
        @errors << "Message is required" if @message.blank?
      else
        conditions = @type_id ? "status_id=#{@type_id}" : nil
        Volunteer.find(:all, :conditions=>conditions).each do |volunteer| 
          VolunteerNotifier.deliver_message(volunteer, @subject, @message)
          @emails << volunteer.person.email
        end
        flash[:notice] = "Message was successfully sent to #{@emails.join(',')}." if @emails.size>0
        #flash[:notice] = "Any volunteer was found with this type" unless @emails.size>0
        redirect_to admin_volunteers_url
      end
    end
   end
  private
  def set_statuses
     @statuses = Status.find_volunteer(:all)
  end
end
