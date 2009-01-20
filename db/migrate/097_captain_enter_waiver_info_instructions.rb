class CaptainEnterWaiverInfoInstructions < ActiveRecord::Migration
  def self.up  
    self.create_page_by_slug("captain-enter-waiver-info-instructions", "Enter Waiver Info Instructions")
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
