class BackController < ApplicationController

  before_action :load_station
  before_action :require_user

  layout('back')

  protected

  def load_station
    @station = Station.where(:url => request.subdomains.first).first
    raise ActionController::RoutingError, "Bad station URL" if @station.nil?
  end

  def check_ownership
    redirect_to(root_back_url) if @station.owner_id != current_user.id
  end

  def require_not_demo
    if @station.demo
      flash[:error] = "Cette fonctionnalité est désactivé en mode démonstration."
      if current_user
        redirect_to(root_back_url)
      else
        redirect_to(login_url)
      end
    end
  end

end