class SearchController < ApplicationController
  respond_to :html, :json

  def search
    query = params[:query]

    users = User.where('concat_ws(\' \', first_name, last_name) ILIKE ?', "%#{query}%").limit(5) or nil

    posts = Post.where('title ILIKE ?', "%#{query}%").limit(5) or nil

    categories = Category.where('name ILIKE ?', "%#{query}%").limit(5) or nil

    #tags = Post.where('tags ILIKE ?', "%#{query}%").limit(5) or nil

    search = {"suggestions" => []}

    if posts.any?
      posts.each do |post|
        search["suggestions"].push({"name" => "post:#{post.id}", "value" => post.title[0..50], "data" => {"category" => "Posts"}})
      end
      search["suggestions"].push({"name" => "post:more,text:#{query}", "value" => "more..", "data" => {"category" => "Posts"}})
    end

    if users.any?
      users.each do |user|
        search["suggestions"].push({"name" => "user:#{user.id}", "value" => user.name, "data" => {"category" => "Users"}})
      end
      search["suggestions"].push({"name" => "user:more,text:#{query}", "value" => "more..", "data" => {"category" => "Users"}})
    end

    if categories.any?
      categories.each do |category|
        search["suggestions"].push({"name" => "category:#{category.id}", "value" => category.name, "data" => {"category" => "Categories"}})
      end
    end

    # if tags.any?
    #   tags.each do |post|
    #     search["suggestions"].push({"name" => "post:#{post.id}", "value" => post.tags[0..50], "data" => {"category" => "Tags"}})
    #   end
    #   search["suggestions"].push({"name" => "post:more,text:#{query}", "value" => "more..", "data" => {"category" => "Tags"}})
    # end

    # @search = {
    #   "suggestions" => [
    #     {"name" => "Arun", "value" => "user:arun", "data" => {"category" => "Users"}},
    #     {"name" => "Akshay", "value" => "user:akshay", "data" => {"category" => "Users"}},
    #     {"name" => "Vaishnavi", "value" => "user:vaishnavi", "data" => {"category" => "Users"}},
    #     {"name" => "Anandteerth", "value" => "user:anandteerth", "data" => {"category" => "Users"}},
    #   ]
    # }
    respond_with(search)
  end

  def action
    action_string = URI.unescape(params[:query])

    action = nil
    query = nil

    if action_string.include? ','
      action, query = action_string.split(',')
    end

    action, action_id = action.nil? ? action_string.split(':') : action.split(':')
    query = query.split(':').last if !query.nil?

    case action
    when "post"
      if action_id == "more"
        redirect_to searchposts_url(query)
      else
        redirect_to searchpost_url(action_id)
      end
    when "user"
      if action_id == "more"
        redirect_to searchusers_url(query)
      else
        redirect_to searchuser_url(action_id)
      end
    when "category"
      if action_id == "more"
        redirect_to searchcategories_url(query)
      else
        redirect_to searchcategory_url(action_id)
      end
    else

    end
  end


  def posts
    query = params[:query]
    @posts = Post.where('title ILIKE ?', "%#{query}%").paginate(:page => params[:page], :per_page => 10)
    @context = "[ Search: '" + query + "' ]"
    respond_to do |format|
      format.html { render 'home/posts' }
    end
  end


  def post
    post_id = params[:post_id]
    @post = Post.find(post_id)
    @user = @post.user
    respond_to do |format|
      format.html { render 'posts/show' }
    end
  end


  def users
    query = params[:query]
    @users = User.where('first_name ILIKE ?', "%#{query}%").paginate(:page => params[:page], :per_page => 10)
    @header = "Users - [ Search: '" + query + "' ]"
    respond_to do |format|
      format.html { render 'users/index' }
    end
  end


  def user
    user_id = params[:user_id]
    @user = User.find(user_id)
    respond_to do |format|
      format.html { render 'users/show' }
    end
  end


  def categories
    query = params[:query]
    @categories = Category.where('name ILIKE ?', "%#{query}%")
    respond_to do |format|
      format.html { render 'categories/index' }
    end
  end


  def category
    category_id = params[:category_id]
    @category = Category.find(category_id)
    @posts = @category.posts
    @context = " [ Search: Category " + @category.name + " ]"
    respond_to do |format|
      format.html { render 'home/posts' }
    end
  end
end
