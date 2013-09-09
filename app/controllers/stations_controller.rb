# -*- encoding : utf-8 -*-
class StationsController < FrontController

  skip_before_action :require_html_request, :only => [:check]

  def new
    @station = Station.new
  end

  def create
    @station = Station.new(station_params)
    @user = @station.users.build(user_params)
    if @station.save
      @user.deliver_confirmation_instructions!
      @user.messages.create(:title => "Bienvenue dans SP-Gestion",
                            :body => render_to_string(:partial => 'messages/instructions',
                                                      :layout => false))
      render(:action => :create)
    else
      render(:action => :new)
    end
  end

  def check
    @station = Station::check(params[:station][:name])
  end

  private

  def station_params
    params.require(:station).permit(:name, :url)
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
