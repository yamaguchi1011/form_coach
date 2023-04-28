class PostsController < ApplicationController
  require "open3"
  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
    # @posts = Post.all.includes([:user, :comments]).order(created_at: :desc)
    # @comments = Comment.includes(:post)
  end

  def new
    @post = Post.new
  end

  def analysis
    @post = current_user.posts.build(post_params)
    if @post.body.present? && @post.video.present? && @post.dominant_arm && @post.pitching_form.present?
      video_path = File.absolute_path(@post.video.file.path)
      dominant_arm = @post.dominant_arm
      # Open3.capture3でpythonのコードを実行する。video_pathで動画のURLを、dominant_armで利き腕を渡す。
      @result = Open3.capture3("python form.py #{video_path} #{dominant_arm}")
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
    # キャッシュを使うために追加したコードここから
    # キャッシュを使うために追加したコードここまで
  #   # if @post.invalid?
  #   #   render :new
  #   # end
  

  
  end

# session使う方法で実験中
  def create
    # @post = current_user.posts.build
    # session[:video]["body"] = params[:post][:body]
    
    # # session[:video]["video"] = session[:video]["video"]["url"]
    
    
    # @post = current_user.posts.build(body:params[:post][:body],video:session[:video]["image"])

      
    @post = Post.new(post_params)
      
    if @post.save
      redirect_to posts_path, success: t('defaults.message.created', item: Post.model_name.human)
    else
      
      
      
      flash.now.alert = t('defaults.message.not_created', item: Post.model_name.human)
      render :new, status: :unprocessable_entity
    #   # いったんconfirmに遷移
    #   render posts_confirm_path
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
      # 通常の処理
      # flash.now['danger'] = t('defaults.message.not_updated', item: Post.model_name.human)
      # render :edit
      # turboでpost編集エラー時
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