class Admin::WebsiteController < ApplicationController
  before_filter :login_required
  layout 'comatose_admin'
  
  def index 
  end
end
