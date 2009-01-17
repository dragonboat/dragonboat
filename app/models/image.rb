class Image < ActiveRecord::Base
  has_attachment :content_type => :image,
                 :storage      => :file_system,
                 :path_prefix  => "public/images",
                 #:max_size     => 10.megabytes,
                 :size     => 0.megabyte..10.megabytes,
                 :thumbnails   => { :thumb => '120x120',  :thumb_big => '120x120'  }

  validates_as_attachment
  has_one :thumb, :class_name =>"Image", :foreign_key => :parent_id, :conditions => "thumbnail  = 'thumb'"

  has_one :thumb_big, :class_name =>"Image", :foreign_key => :parent_id, :conditions => "thumbnail = 'thumb_big'"
  belongs_to :user, :foreign_key => 'created_by'
  
  has_one :team, :foreign_key => 'logo_id', :class_name=>"Image"
end
