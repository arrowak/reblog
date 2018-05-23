class HomeController < ApplicationController

  def index
    @activities = PublicActivity::Activity.order("created_at DESC")
  end

  def posts
    @posts = Post.where(:published => true).paginate(:page => params[:page], :per_page => 10).order("created_at DESC")
  end
end
