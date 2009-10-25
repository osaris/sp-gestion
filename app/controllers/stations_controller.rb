class StationsController < FrontController
  
  def new
    @station = Station.new
  end
  
  def create
    @station = Station.new(params[:station])
    @user = @station.users.build(params[:user])
    if @station.save
      @user.deliver_confirmation_instructions!
      render(:action => :create)
    else
      render(:action => :new)
    end
  end
  
end