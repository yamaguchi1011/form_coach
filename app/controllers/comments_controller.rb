class CommentsController < ApplicationController
  def index
    @comments = Comment.all.includes([:user, :effective]).order(created_at: :desc)
  end

  def show
    @comment = Comment
    @user
  end


  def create
    @comment = current_user.comments.build(comment_params)
    @post = Post.find(params[:post_id])
    if @comment.save
      redirect_to post_path(@comment.post)
      flash.now.notice= t('defaults.message.updated', item: User.model_name.human)
    else
      redirect_to post_path(@comment.post), danger: t('defaults.message.not_comment', item: Comment.model_name.human)
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
