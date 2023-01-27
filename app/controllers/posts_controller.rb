class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  # before_action :post_params, only: analysis
  require "open3"
  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def analysis
    @post = current_user.posts.build(post_params)
    # @post = current_user.posts.build(@attr)
    file_name = params[:post][:video]
    # File.absolute_pathで渡された動画のパスを絶対パスにしてvideo_pathに入れる。
    video_path = File.absolute_path(@post.video.file.path)
    # session情報を削除する。
    session.delete(:video)
    # sessionにユーザーが渡した情報を入れる
    session[:video] = @post
    # Open3.capture3でpythonのコードを実行した後
    @result = Open3.capture3("python form.py #{video_path}")
    
    # @resultに分析後の動画のURLが入っていたら確認画面に遷移する。
    # 動画を最初に選んだ時で分析するをクリックしたときにtmpファイルに一時的に保存されて、
    # 同じ場所に分析後の動画を上書きされている。正確には前の動画を消して、分析後の動画を同じURLで保存する。
    if @result  
      redirect_to posts_confirm_path, success: "分析成功しました"
    end

    
    # 動画を分析した後は元の動画を削除する。
  end

  def confirm
    @post = Post.new(session[:video])
    
    # if @post.invalid?
    #   render :new
    # end
  end

# session使う方法で実験中
  def create
    @post = current_user.posts.build(post_params)
    # session[:video]["body"] = params[:post][:body]
    
    # # session[:video]["video"] = session[:video]["video"]["url"]
    
    # @post = current_user.posts.build(body:params[:post][:body],video:session[:video]["video"]["url"])
    

binding.pry

    
    if @post.save!
      redirect_to posts_path, success: t('defaults.message.created', item: Post.model_name.human)
    # else
    #   flash.now['danger'] = t('defaults.message.not_created', item: Post.model_name.human)
    #   # render :new
    #   # いったんconfirmに遷移
    #   render posts_confirm_path
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :video, :video_cache)
  end
end