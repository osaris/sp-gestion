# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  layout("front")

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  rescue_from ActionController::RoutingError, :with => :redirect_to_homepage
  
  private

  def redirect_to_homepage
    redirect_to(root_pub_path)
  end    
end
