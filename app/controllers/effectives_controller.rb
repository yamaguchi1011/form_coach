class EffectivesController < ApplicationController
  def create

    @comment = Comment.find(params[:comment_id])
    current_user.effective(@comment)
    redirect_to post_path(@comment.post_id), success: t('.success')

    # # 非同期実装
    # @comment = Comment.find(params[:comment_id])
    # current_user.effective(@comment)
    # respond_to do |format|
    #   format.html { redirect_to posts_path }
    #   format.turbo_stream
    # end
  end

  def destroy

    @comment = current_user.effectives.find(params[:id]).comment
    current_user.uneffective(@comment)
    redirect_to post_path(@comment.post_id), success: t('.success')

    # # 非同期処理
    # @comment = current_user.effectives.find(params[:id]).comment
    # current_user.uneffective(@comment)
    # respond_to do |format|
    #   # format.html { redirect_to posts_path }
    #   format.turbo_stream
    # end
  end
end