class AddInstructionsPage5 < ActiveRecord::Migration
  def self.up
  #-------step5-instructions---------------------------------------------------------#
      @page = Comatose::Page.find_by_slug('step5-instructions')
      @page.destroy if  @page
      @page = Comatose::Page.new
      @page.author = 'admin'
      @page.parent_id = 1
      @page.is_page = false
      @page.title = "Step5 Instructions"
      @page.slug = "step5-instructions"
      @page.full_path = "step5-instructions"
      @page.body = %Q(
Please review all of the information below and make sure it is correct before you continue.  If you need to change anything, please use you
      )
     @page.valid? &&   @page.save!
     
    
     #-------step5-instructions-2---------------------------------------------------------#
      @page = Comatose::Page.find_by_slug('step5-instructions-2')
      @page.destroy if  @page
      @page = Comatose::Page.new
      @page.author = 'admin'
      @page.parent_id = 1
      @page.is_page = false
      @page.title = "Step5 Instructions 2"
      @page.slug = "step5-instructions-2"
      @page.full_path = "step5-instructions-2"
      @page.body = %Q(
By clicking the box below to complete your registration, you agree to all of the following:
<ul id="none_style" >
<li>-That you have read the [terms and conditions of team registration]</li>
<li>-That you agree to the [Responsibilities of a Captain] </li>
<li>-That you will abide by all of the [rules of the river] </li>
</ul>
Once you click the button below, your credit card will be charged and your team will be registered.

      )
     @page.valid? &&   @page.save!
  end

  def self.down
  end
end
