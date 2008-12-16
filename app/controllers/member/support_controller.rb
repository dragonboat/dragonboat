class Member::SupportController < ApplicationController
  before_filter :login_required, :is_not_admin?, :fetch_user
  layout 'member'

def index
  @tickets = @user.tickets.find_pending(:all)
end

def show
  begin
    @ticket = @user.tickets.find(params[:id])
  rescue Exception 
  end
end

def reply
  #params[:answer_id]  - answer id
  #params[:id] - ticket id
  @parent = @user.tickets.find(params[:id])
  @ticket = @user.tickets.build
  @ticket.parent_id = @parent.id
  @ticket.email = @parent.email
  @answer = @ticket.answers.find(params[:answer_id])
end

private
  def is_not_admin?
    !current_user.is_admin? ? true : access_denied
  end
  
  def fetch_user
    @user = current_user
  end
  
  def access_denied
      respond_to do |format|
        format.html do
          store_location 
          if current_user
            redirect_to admin_index_path if current_user.is_admin?
            redirect_to member_index_path unless current_user.is_admin?
          else
            redirect_to new_session_path
          end
        end
        format.any do
          request_http_basic_authentication 'Web Password'
        end
      end
      false
  end
end
