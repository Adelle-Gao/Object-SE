class TopicsController < ApplicationController
  before_filter :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @forum = Forum.find(params[:forum_id])
    @topics_pages, @topics = paginate(:topics,
                  :include => :user,
                  :conditions => ['forum_id = ?', @forum],
                  :order => 'topics.updated_at DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics }
    end
  end

  def show
    respond_to posts_path(:forum_id => params[:forum_id],:topic_id => params[:id])
  end

  def new
    @topic = Topic.new
    @post = Post.new
  end

  def edit
    @topic = Topic.find(params[:topic])
  end

  def create
    @topic = Topic.new(:name => params[:topic][:name],
                      :forum_id => params[:forum_id],
                      :user_id => logged_in_user.id)
    @topic.save!
    @post = Post.new(:body => params[:post][:body],
                    :topic_id => @topic.id,
                    :user_id => logged_in_user.id)
    @post.save!

    respond_to do |format|
      format.html { redirect_to posts_path(:topic_id => @topic,
                                          :forum_id => @topic.forum.id)}
      format.json { head :created,:location => topic_path(:id =>@topic,
                                                          :forum_id => @topic.forum.id)}
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.html { render acton: 'new'}
      format.json { render json: @topic.errors, status: :unprocessable_entity }
    end
  end

  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to posts_path(:topic_id => @topic, :forum_id =>@topic.forum),
                      notice: 'Topic was successfully updated.'}
        format.json { head :ok}
      else
        format.html { render action: 'edit'}
        format.xml { render json: @topic.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.posts.esch { |post| post.destroy }
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics.path(:forum_id => params[:forum_id])}
      format.json { head :no_content }
    end
  end

  private
    def set_topic
      @topic = Topic.find(params[:id])
    end
end
