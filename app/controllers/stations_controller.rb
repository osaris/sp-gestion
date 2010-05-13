class StationsController < FrontController

  def new
    @station = Station.new
  end

  def create
    @station = Station.new(params[:station])
    @user = @station.users.build(params[:user])
    if @station.save
      @user.send_later(:deliver_confirmation_instructions!)
      @user.messages.create(:title => "Bienvenue dans SP-Gestion",
                            :body => render_to_string(:partial => 'messages/instructions',
                                                      :layout => false))
      render(:action => :create)
    else
      render(:action => :new)
    end
  end

  def check
    @station = Station::check(params[:name])
  end
end