class BackController < ApplicationController
  
  before_filter :load_station
  before_filter :require_user
    
  skip_after_filter :add_google_analytics_code
  
  layout('back')

  protected
  
  def load_station
    @station = Station.find(:first, :conditions => {:url => request.subdomains.first})
    raise ActionController::RoutingError, "Bad station URL" if @station.nil?
  end
  
end