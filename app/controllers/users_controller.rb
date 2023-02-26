class UsersController < ApplicationController
  skip_before_action :require_login, only: [:top, :new, :create] 
  def new
    @user = User.new
  end

  def show
    # @posts = User.posts.order("created_at DESC")
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, success: t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
