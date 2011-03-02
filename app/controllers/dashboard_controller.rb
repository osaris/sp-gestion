# -*- encoding : utf-8 -*-
class DashboardController < BackController
  
  navigation(:dashboard)
  
  helper(:interventions)
  
  def index
    @convocations = @station.convocations.newer.limit(5)
    @interventions = @station.interventions.newer.limit(5)
    @items = Item.expirings(30, @station.id).limit(5)
    @messages = current_user.messages.unread
  end
  
end
