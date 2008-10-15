class ManageImagesController < ApplicationController
  def index
    @images= current_user.images
    
    render :update do |page|
      page.replace_html :dynamic_images_list, :partial => 'show_image_list', :locals => { :images => @images }
    end
  end

end
