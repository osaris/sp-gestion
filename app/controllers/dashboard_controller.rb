class DashboardController < BackController
  
  navigation(:dashboard)
  
  def index
    @messages = current_user.messages.unread
    @convocations = @station.convocations.last(5)
  end
  
end