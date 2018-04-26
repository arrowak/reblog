class OmniauthCallbacksController < ApplicationController
  # replace with your authenticate method
  skip_before_action :authenticate_user!, :only => "reply", :raise => false

  def google_oauth2
    auth = request.env["omniauth.auth"]
    user = User.where(provider: auth["provider"], uid: auth["uid"])
    .first_or_initialize do |member|
      member.first_name = auth["info"]["first_name"]
      member.last_name = auth["info"]["last_name"]
      member.email = auth["info"]["email"]
      member.picture = auth["info"]["image"]
    end

    user.password = Devise.friendly_token[0,20]
    user.save!

    user.remember_me = true
    sign_in(:user, user)

    redirect_to after_sign_in_path_for(user)
  end
end
