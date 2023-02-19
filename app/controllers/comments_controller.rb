class CommentsController < ApplicationController


  def index
    @comments = Comment.all.includes([:user, :effective]).order(created_at: :desc)
  end

  def show
    @comment = Comment
  end


  def create
    @comment = current_user.comments.build(comment_params)
    # # @comments = Comment.all.includes([:user, :effective]).order(created_at: :desc)
    @post = Post.find(params[:post_id])
    if @comment.save
      redirect_to post_path(@comment.post)
      # turboでcreate.turbo_stream.erbを呼び出してコメント投稿は非同期で実装できたが、コメント記述欄のリセットができないので保留
      # render :create
    else
      redirect_to post_path(@comment.post), danger: t('defaults.message.not_comment', item: Comment.model_name.human)
      # render :_form, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    redirect_to post_path(@comment.post)
  end

  def effectives
    @effective_comments = current_user.effective_comments.includes(:user).order(created_at: :desc)
  end


  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end
end
