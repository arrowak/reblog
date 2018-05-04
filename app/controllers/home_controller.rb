class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @activities = nil
  end

  def posts
    @posts = Post.all.order("created_at DESC")
  end
end
