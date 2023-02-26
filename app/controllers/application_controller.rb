class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :info, :warning, :danger
  def appropriate_flash
    case
    when request.format.turbo_stream?
      flash.now
    else
      flash
    end
  end
end
