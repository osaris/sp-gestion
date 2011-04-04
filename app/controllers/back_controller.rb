# -*- encoding : utf-8 -*-
class BackController < ApplicationController

  before_filter :load_station
  before_filter :require_user

  layout('back')

  protected

  def load_station
    @station = Station.where(:url => request.subdomains.first).first
    raise ActionController::RoutingError, "Bad station URL" if @station.nil?
  end

  def check_ownership
    redirect_to(root_back_url) if @station.owner_id != current_user.id
  end

end