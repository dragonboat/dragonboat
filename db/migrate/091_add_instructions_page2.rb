class AddInstructionsPage2 < ActiveRecord::Migration
  def self.up
    #-------step2-instructions---------------------------------------------------------#
      @page = Comatose::Page.find_by_slug('step2-instructions')
      @page.destroy if  @page
      @page = Comatose::Page.new
      @page.author = 'admin'
      @page.parent_id = 1
      @page.is_page = false
      @page.title = "Step2 Instructions"
      @page.slug = "step2-instructions"
      @page.full_path = "step2-instructions"
      @page.body = %Q(
To register your team, please provide a team name and select your type of team below.  If you have a team profile, website, or logo you can add it here now, or you can wait and add it after you have completed your team registration.  Field names in ORANGE are REQUIRED.

)
     @page.valid? &&   @page.save!
  end

  def self.down
  end
end
