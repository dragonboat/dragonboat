class Admin::WebsiteController < ApplicationController
  before_filter :admin_login_required
  layout 'comatose_admin'
  
  def index 
  end
end
