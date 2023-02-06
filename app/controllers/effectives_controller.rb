class EffectivesController < ApplicationController
  def create
    @comment = Comment.find(params[:comment_id])
    
    current_user.effective(@comment)
    redirect_to post_path(@comment.post_id), success: t('.success')
    # respond_to do |format|
    #   format.html { redirect_to posts_path }
    #   format.js
    # end
  end

  def destroy
    @comment = current_user.effectives.find(params[:id]).comment
    current_user.uneffective(@comment)
    redirect_to post_path(@comment.post_id), success: t('.success')
    # respond_to do |format|
    #   format.html { redirect_to posts_path }
    #   format.js
    # end
  end
end