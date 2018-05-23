class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :comments, as: :commentable
  has_attached_file :cover_picture, styles: { medium: "640x427>", thumb: "320x212>" }, :storage => :cloudinary, :path => ':id/:style/:filename', :cloudinary_resource_type => :image
  validates_attachment_content_type :cover_picture, content_type: /\Aimage\/.*\z/
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  acts_as_likeable

  def get_tags
    tags.split(',')
  end

  def published?
    published
  end
end
