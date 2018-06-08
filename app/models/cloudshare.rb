class Cloudshare < ApplicationRecord
  has_attached_file :image, :storage => :cloudinary, :path => ':id/:style/:filename', :cloudinary_resource_type => :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

end
