class PostsController < ApplicationController
  require "open3"
  require 'aws-sdk-s3'
  require "tempfile"

  before_action :set_post, only: [:edit, :update, :destroy]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new
    @post = Post.new
  end 

  def analysis
    @post = current_user.posts.build(post_params)
    if @post.body.present? && @post.video.present? && @post.dominant_arm && @post.pitching_form.present?
      video_path = File.absolute_path(@post.video.file.path)
      dominant_arm = @post.dominant_arm
      stdout,stderr,status = Open3.capture3("source ./venv/bin/activate && python ./form.py #{video_path} #{dominant_arm}")
      if @post.save
        redirect_to posts_path, success: t('defaults.message.created', item: Post.model_name.human)
      end
    else
      flash.now.alert = t('defaults.message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def confirm
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path, success: t('defaults.message.created', item: Post.model_name.human)
    else
      flash.now.alert = t('defaults.message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, success: t('defaults.message.updated', item: Post.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_path, success: t('defaults.message.deleted', item: Post.model_name.human)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :video, :video_cache, :dominant_arm, :pitching_form)
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end