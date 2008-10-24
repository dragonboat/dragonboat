class News < ActiveRecord::Base
  VISIBLES = [['on', true],['off',false]]
  belongs_to :cover_image, :class_name=> "Image", :foreign_key => :cover_image_id
  belongs_to :user, :foreign_key => :created_by
 
  scope_out :visible,
            :conditions => "is_visible IS TRUE",
            :order =>"published_at DESC"
          
  validates_uniqueness_of :title, :scope => [:published_at]

  acts_as_taggable
  validates_presence_of :title
  
  scope_out :actual,
            :conditions => "is_visible IS TRUE AND UNIX_TIMESTAMP(published_at)<= '#{Time.now.to_i}'",
            :order => 'published_at DESC'
     
  def published
    data_is_visible== true ? published_at.strftime("%d/%m/%Y") : ""
  end
end
