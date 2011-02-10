class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user

  rescue_from ActionController::RoutingError, :with => :redirect_to_homepage
  rescue_from ActionController::UnknownController, :with => :redirect_to_homepage
  rescue_from ActionController::UnknownAction, :with => :redirect_to_homepage

  private

  def redirect_to_homepage
    redirect_to("http://www.#{BASE_URL}")
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    redirect_to(login_url) and return false unless current_user
  end

  def require_no_user
    redirect_to(root_back_url) and return false if current_user
  end
end
