class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login

  #----------

  helper_method :current_user

  def current_user
    begin
      @current_user ||= User.where(can_login: true).find(session[:user_id])
    rescue ActiveRecord::RecordNotFound
      session[:user_id]   = nil
      @current_user       = nil
    end
  end

  def require_login
    if current_user
      return true
    else
      session[:return_to] = request.fullpath
      redirect_to login_path and return false
    end
  end
end

