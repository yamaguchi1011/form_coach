
class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update show]
  before_action :user_effectives_count, only: %i[edit update show]
  
  def edit;end

  def update
    if @user.update(user_params)
      flash.now.notice= t('defaults.message.updated', item: User.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @posts = @user.posts.order("created_at DESC")
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_effectives_count
    @user_effectives_count = @user.comment_effectives.size
  end

  def user_params
    params.require(:user).permit(:email, :name, :avatar, :avatar_cache)
  end
end