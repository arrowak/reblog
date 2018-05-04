class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @activities = PublicActivity::Activity.order("created_at DESC")
  end

  def posts
    @posts = Post.all.order("created_at DESC")
  end
end
