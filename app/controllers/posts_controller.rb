class PostsController < ApplicationController
  # before_action :set_post, only: %i[ show edit update destroy ]
  # before_action :post_params, only: analysis
  require "open3"
  def index
    @posts = Post.all.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def analysis
    # 戻れるコード
    @post = current_user.posts.build(post_params)
    # 実験のコード
    # @post = Post.new(post_params)
    # file_name = params[:post][:video]
    # File.absolute_pathで渡された動画のパスを絶対パスにしてvideo_pathに入れる。
    
    video_path = File.absolute_path(@post.video.file.path)
    dominant_arm = @post.dominant_arm
    # session情報を削除する。
    session.delete(:video)
    # sessionにユーザーが渡した情報を入れる
    session[:video] = @post
    

    # sessionにparamsの動画の名前を入れる
    # session[:video] = @post.video
  
    # session[:video]["video"]["url"] = @post.video.file.file
    # session[:video]["image"] = @post.video.file.original_filename
    # Open3.capture3でpythonのコードを実行する。video_pathで動画のURLを、dominant_armで利き腕を渡す。
    @result = Open3.capture3("python form.py #{video_path} #{dominant_arm}")

    
    # @resultに分析後の動画のURLが入っていたら確認画面に遷移する。
    # 動画を最初に選んだ時で分析するをクリックしたときにtmpファイルに一時的に保存されて、
    # 同じ場所に分析後の動画を上書きされている。正確には前の動画を消して、分析後の動画を同じURLで保存する。


    #確認画面を経由せずに投稿はうまく行く ここから
    if @post.save!
      redirect_to posts_path, success: t('defaults.message.created', item: Post.model_name.human)
    end
    # 確認画面を経由せずに投稿はうまく行く ここまで

    # 確認画面用
    # if @result  
      # ページ移動できるが、、、@postがnil
      # redirect_to posts_confirm_path(post: @post), success: "分析成功しました"
    #   # 実験
      # redirect_to action: :confirm
      # render :confirm
    # end
    # end
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
    @post.video.retrieve_from_cache! params[:cache][:video]
      
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
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  private

  def post_params
    # require(:post)があるとエラーになる。confirm.html.erbは@postに値が入っているのでエラーになる？
    # 逆にnew.html.erbは_form.html.erbをrenderする際にpostに@postを渡していて、_form.htmlではpostに値を入れているからちゃんと動く？
    params.require(:post).permit(:title, :body, :video, :video_cache, :dominant_arm)
    # params.permit(:title, :body, :video, :video_cache)
  end
end