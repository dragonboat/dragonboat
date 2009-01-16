class AddInstructionsPage3 < ActiveRecord::Migration
  def self.up
     #-------step3-instructions---------------------------------------------------------#
      @page = Comatose::Page.find_by_slug('step3-instructions')
      @page.destroy if  @page
      @page = Comatose::Page.new
      @page.author = 'admin'
      @page.parent_id = 1
      @page.is_page = false
      @page.title = "Step3 Instructions"
      @page.slug = "step3-instructions"
      @page.full_path = "step3-instructions"
      @page.body = %Q(
The Athletes Village will run along the water's edge along the entire race course and beyond.  Here you can decide how many tents you want setup for your team on race day.  After you complete the team registration process you will be able to reserve the positions for your tents on the race course.  You are allowed to order a maximum of 6 tents.

PLEASE NOTE: only the first 2 tents will be placed on the water's edge, and all additional tents will be placed behind the first two that you reserve.  

How many tents would you like to reserve?
      )
     @page.valid? &&   @page.save!
  end

  def self.down
  end
end
