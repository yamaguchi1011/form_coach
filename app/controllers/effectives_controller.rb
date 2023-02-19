class EffectivesController < ApplicationController
  def create
    @comment = Comment.find(params[:comment_id])
    current_user.effective(@comment)
    redirect_to post_path(@comment.post_id)
  end

  def destroy
    @comment = current_user.effectives.find(params[:id]).comment
    current_user.uneffective(@comment)
    redirect_to post_path(@comment.post_id)
  end
end