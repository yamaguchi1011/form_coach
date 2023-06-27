class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_search
  add_flash_types :success, :info, :warning, :danger
  def appropriate_flash
    case
    when request.format.turbo_stream?
      flash.now
    else
      flash
    end
  end

  def set_search
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc)
  end

end
