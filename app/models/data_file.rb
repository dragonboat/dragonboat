class DataFile < ActiveRecord::Base
  #table_name "data_files"
  has_attachment :content_type => ['application/pdf', 'application/msword', 'text/plain'],
                 :storage      => :file_system,
                 :path_prefix  => "public/files",
                 :size     => 0.megabyte..10.megabytes
  validates_as_attachment
  belongs_to :user, :foreign_key => 'created_by'

  def size
    return unless content_type 
   (File.exist?(full_filename) ? File.size(full_filename) : 0)
  end

  def thumb
    "icons/" + content_type.gsub(/\//, '_').downcase + ".gif"
  end
end
