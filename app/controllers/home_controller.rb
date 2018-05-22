class HomeController < ApplicationController

  def index
    @activities = PublicActivity::Activity.order("created_at DESC")
  end

  def posts
    @posts = Post.paginate(:page => params[:page], :per_page => 1).order("created_at DESC")
  end
end
