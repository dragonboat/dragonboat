class AddInstructionsToCaptainsPagesSnippet < ActiveRecord::Migration
  def self.up
    self.create_page_by_slug('manage-team-add-new-member-instructions', "Manage Team - Add New Member Instructions")
    self.create_page_by_slug('edit-team-member-instructions', "Edit Team Member Instructions")
    
    self.create_page_by_slug('edit-team-member-account-information-instructions', "Edit Team Member Account Information Instructions")
    self.create_page_by_slug('edit-team-member-personal-information-instructions', "Edit Team Member Personal Information Instructions")
    self.create_page_by_slug('edit-team-member-position-field-instructions', "Edit Team Member Position Field Instructions")
   
    self.create_page_by_slug('show-team-member-instructions', "Show Team Member Instructions")
    self.create_page_by_slug('manage-practices-instructions', "Manage Practices Instructions")
    self.create_page_by_slug('practice-schedule-instructions', "Practice Schedule Instructions")
   
    self.create_page_by_slug('reserve-practice-time-instructions', "Reserve Practice Time Instructions")
    self.create_page_by_slug('practice-form-launch-driver-field-instructions', "Practice Form Launch Driver Field Instructions")
    self.create_page_by_slug('practice-form-steers-person-field-instructions', "Practice Form Steers Person Field Instructions")
  
    self.create_page_by_slug('cancel-scheduled-practice-time-instructions', "Cancel Scheduled Practice Time Instructions")
    self.create_page_by_slug('listing-orphaned-paddlers-instructions', "Listing Orphaned Paddlers Instructions")
    self.create_page_by_slug('general-paddler-info-instructions', "General Paddler Info Instructions")
    
    self.create_page_by_slug('invite-to-join-team-instructions', "Invite To Join Team Instructions")
    self.create_page_by_slug('invite-to-join-team-team-name-field-instructions', "Invite To Join Team Team Name Field Instructions")
    self.create_page_by_slug('invite-to-join-team-member-type-field-instructions', "Invite To Join Team Member Type Field Instructions")
    
    self.create_page_by_slug('invite-to-join-team-personal-information-instructions', "Invite To Join Team Personal Information Instructions")
    self.create_page_by_slug('invite-to-join-team-preferences-field-instructions', "Invite To Join Team Preferences Field Instructions")
    self.create_page_by_slug('edit-team-instructions', "Edit Team Instructions")
   
    self.create_page_by_slug('team-home-instructions', "Team Home Instructions")    
    self.create_page_by_slug('team-list-instructions', "Team List Instructions")
    self.create_page_by_slug('pending-support-tickets-list-instructions', "Pending Support Tickets List Instructions")
    self.create_page_by_slug('show-ticket-instructions', "Show Ticket Instructions")
   
  end

  def self.down
  end
  private
  def self.create_page_by_slug(slug, title)
    page = Comatose::Page.find_by_slug(slug)
    unless page
      page = Comatose::Page.new
      page.author = 'admin'
      page.parent_id = 1
      page.is_page = false
      page.title = title
      page.slug = slug
      page.full_path = slug
      page.valid? && page.save!
    end
  end
end
