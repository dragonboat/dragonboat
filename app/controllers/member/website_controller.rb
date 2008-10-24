class Member::WebsiteController < ApplicationController
 before_filter :login_required
 layout 'member'
  
 def index 
 end
 
 private
   def access_denied
      respond_to do |format|
        format.html do
          store_location
          if current_user
            redirect_to member_index_path
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
