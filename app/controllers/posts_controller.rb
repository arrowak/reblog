class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like]
  before_action :set_user
  before_action :authenticate_user!


  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where(:user => @user)
    respond_to do |format|
      format.html { render "home/posts" }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @title = @post.title
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = @user

    respond_to do |format|
      if @post.save
        format.html { redirect_to user_post_path(@user, @post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to user_post_path(@user, @post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to user_posts_path(@user), notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    current_user.like!(@post)
    if current_user.likes?(@post)
      render html: @post.likers(User).count
    else
      render html: "false"
    end
  end

  def search
    query = params[:query]
    @posts = Post.where('title ILIKE ?', "%#{query}%")
    @context = "[ Search: '" + query + "' ]"
    respond_to do |format|
      format.html { render 'home/posts' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id] || params[:post_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :body, :tags, :category_id, :cover_picture, :likees_count)
  end

  def set_user
    @user = params[:user_id].present? ? User.find(params[:user_id]) : @post.user
  end
end
