class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :posts
  has_many :comments, through: :posts
  has_many :comments


  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/user_default_dark.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  acts_as_liker
  acts_as_mentionable
  acts_as_follower
  acts_as_followable

  # Function to concatenate the first name and last name of the user
  def name
    if !first_name.nil? and !last_name.nil?
      first_name + " " + last_name
    else
      email
    end
  end

  # Function to output appropriate profile picture of the user
  # using avatar, picture and default_image fallback heirarchy
  def profile_picture
    !self.avatar? ? (!self.picture.present? ? ActionController::Base.helpers.asset_path("user_default.png", :digest => false) : self.picture) : self.avatar.url
  end

  # Function to find the user who has logged-in from social domain in our system.
  # This will create a new user if not already existing
  def self.find_or_create_from_auth_hash(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.password = Devise.friendly_token[0,20]
      user.email = auth.info.email
      user.picture = auth.info.image
      user.save!
    end
  end
end
