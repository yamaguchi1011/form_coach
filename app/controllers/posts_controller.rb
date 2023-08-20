class PostsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  require "open3"
  require 'aws-sdk-s3'
  require "tempfile"
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
      # 与えられたパスを絶対パスに変換する。
      video_cache_path = File.absolute_path(@post.video.file.path)
      # ユーザーの利き腕ごとで、分析する座標が変更されるため、利き腕をdominant_armに格納する。
      dominant_arm = @post.dominant_arm
      s3 = Aws::S3::Client.new(
          region: ENV['AWS_REGION'],
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        )
        bucket_name = ENV['AWS_BUCKET'] 
        object_key = video_cache_path 
      # S3オブジェクトを一時ディレクトリにダウンロード
      File.open("/tmp/downloaded_video.mp4", 'wb') do |file|
        s3.get_object(bucket: bucket_name, key: object_key, response_target: file.path)
      end
      # 一時ディレクトリのパスをvideo_pathに格納
      video_path = "/tmp/downloaded_video.mp4"
      # Open3.capture3でpythonのコードを実行する。video_pathで動画のURLを、dominant_armで利き腕を渡す。
      stdout,stderr,status = Open3.capture3("source ./venv/bin/activate && python ./form.py #{video_path} #{dominant_arm}")
      # 分析が成功したらS3へのアップロードを実行
      if status.success?
        # AWS S3へのアップロード
        s3 = Aws::S3::Resource.new(
          region: ENV['AWS_REGION'],
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        )
        bucket_name = ENV['AWS_BUCKET'] 
        # S3に動画をアップロード
        s3.bucket(bucket_name).object(object_key).upload_file(video_path)
        # 不要になった一時ファイルを削除
        File.delete("/tmp/downloaded_video.mp4")
        # ポストを保存
        if @post.save!
          redirect_to posts_path, success: t('defaults.message.created', item: Post.model_name.human)
        else
          flash.now.alert = "投稿ができませんでした。"
          render :new, status: :unprocessable_entity
        end
      else
        # 不要になった一時ファイルを削除
        File.delete("/tmp/downloaded_video.mp4")
        # なんらかの原因で解析に失敗したら表示
        flash.now.alert = "動画の分析に失敗しました。"
        render :new, status: :unprocessable_entity
      end
    else
      # postの内容に入力忘れなどがあると投稿失敗
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

  # turboで投稿詳細画面を画面遷移なく表示するためにdetailアクションを作成
  def detail
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end
  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, success: t('defaults.message.updated', item: Post.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
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