class AddInstructionsPage4 < ActiveRecord::Migration
  def self.up
      #-------step4-instructions---------------------------------------------------------#
      @page = Comatose::Page.find_by_slug('step4-instructions')
      @page.destroy if  @page
      @page = Comatose::Page.new
      @page.author = 'admin'
      @page.parent_id = 1
      @page.is_page = false
      @page.title = "Step4 Instructions"
      @page.slug = "step4-instructions"
      @page.full_path = "step4-instructions"
      @page.body = %Q(
Please enter your credit card information below to pay for your team registration and tent reservations (if any).  A charge will appear on your credit card statement from "PHILADELPHIA INTERNATIONAL DRAGON BOAT FESTIVAL".  If you experience any problems during the payment process please submit a support ticked to our support system here or send an email to support@philadragonboatfestival.com
      )
     @page.valid? &&   @page.save!
  end

  def self.down
  end
end
