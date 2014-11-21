class PostsController < ApplicationController
  before_filter :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @topic = Topic.find(params[:topic_id], :include => :forum )
    @posts_pages, @posts = paginate(:posts, :include => :user, :conditions =>['topic_id = ?',@topic])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def show
    respond_with(@post)
  end

  def new
    @topic = Topic.find(params[:topic_id], :include => :forum )
    @post = Post.new
    #respond_with(@post)
  end

  def edit
    @post =Post.find(params[:id], :include => {:topic => :forum})
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = Post.new(:body => params[:post][:body],
                      :topic_id => @topic.id,
                      :user_id => logged_in_user.id)
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path(:forum_id => @topic.forum_id,
                                            :topic_id => @topic),
                      notice: 'Post was successfully created.'}
        format.json { render json: @post, status: :created, :location => post_path(@post)}
      else
        format.html { render :action => 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @post = Post.find(params[:id])
    respond_to do |format|
     if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to posts_path(:forum_id => params[:forum_id], 
                                            :topic_id => params[:topic_id]),
                      notice: 'Post was successfully updated.'}
       format.json {head :no_content}
      else
        format.html { render :action => 'edit'}
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_path(:forum_id => params[:forum_id],
                                          :topic_id => params[:topic_id])}
      format.json { head :no_content }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end
end
