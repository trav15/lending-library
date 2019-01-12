class ApplicationController < ActionController::Base

  helper_method :logged_in?, :current_user

  private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def redirect_if_not_logged_in!
    if !logged_in?
      flash[:errors] = "You must be logged in to complete this action!"
      redirect_back fallback_location: root_path
    end
  end
end
