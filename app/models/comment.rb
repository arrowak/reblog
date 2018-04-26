class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
  validates :body, presence: true
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
end
