class Post < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :comments, as: :commentable
  has_attached_file :cover_picture, styles: { medium: "640x427>", thumb: "320x212>" }
  validates_attachment_content_type :cover_picture, content_type: /\Aimage\/.*\z/
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
end
