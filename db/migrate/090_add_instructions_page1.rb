class AddInstructionsPage1 < ActiveRecord::Migration
  def self.up
    
    #-------step1-instructions---------------------------------------------------------#
      @page = Comatose::Page.find_by_slug('step1-instructions')
      @page.destroy if  @page
      @page = Comatose::Page.new
      @page.author = 'admin'
      @page.parent_id = 1
      @page.is_page = false
      @page.title = "Step1 Instructions"
      @page.slug = "step1-instructions"
      @page.full_path = "step1-instructions"
      @page.body = %Q(
Please enter all of your personal information below to begin the Team Registration process.  You should only complete this form if you are a team captain who is registering a team for the 2009 Philadelphia International Dragon Boat Festival.  If you have already registered one team and are trying to register an additional one, please  <a href='http://phillydragonboat.info/login'>click here to login</a> and use the "register another team" feature.

Please Note:  In order to complete a team registration you will need to have decided on your Team Name and have a valid credit card to pay for the team registration fee and tent reservations.

)
     @page.valid? &&   @page.save!
   
    #-------step1-instructions-2----------------------------------------------------------#
    @page = Comatose::Page.find_by_slug('step1-instructions-2')
      @page.destroy if  @page
      @page = Comatose::Page.new
      @page.author = 'admin'
      @page.parent_id = 1
      @page.is_page = false
      @page.title = "Step1 Instructions 2"
      @page.slug = "step1-instructions-2"
      @page.full_path = "step1-instructions-2"
      @page.body = %Q(
After you complete registration, you will be able to login to our online team management system to invite other team members, update team information, and schedule your practices.
)
     @page.valid? &&   @page.save!
  end

  def self.down
  end
end
