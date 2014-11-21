class ForumsController < ApplicationController
  before_filter :set_forum, only: [:show, :edit, :update, :destroy]
  #GET /forums/new
  #GET /forums/new.json
  def index
    @forums = Forum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json:@forums }
    end
  end

  def show
    redirect_to topics_path(:forum_id => params[:id])
  end

  def new
    @forum = Forum.new

    respond_to do |format|
      format.html #new.html.erb
      format.json { render json: @forum }
    end
  end

  def edit
    @forum = Forum.find(params[:id])
  end

  def create
    @forum = Forum.new(params[:forum])

    respond_to do |format|
      if @forum.save
        format.html { redirect_to @forum, notice: 'Forum was successfully created.' }
        format.json  { render json: @forum, status: :created, location: @forum }
      else
        format.html { render action: "new" }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @forum = Forum.find(params[:id])
    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        format.html { redirect_to @forum, notice: 'Forum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html {render action: "edit" }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    respond_to do |format|
      format.html { redirect_to forums_url }
      format.json { head :no_content }
    end
  end

  private
    def set_forum
      @forum = Forum.find(params[:id])
    end

end
