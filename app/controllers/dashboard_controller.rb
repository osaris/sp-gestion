class DashboardController < BackController
  
  navigation(:dashboard)
  
  def index
    @messages = current_user.messages.unread
    @convocations = @station.convocations.newer.limit(5)
    @items = Item.expirings(30, @station.id).limit(5)
  end
  
end