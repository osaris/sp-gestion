class DashboardController < BackController

  helper(:interventions)

  def index
    # authorization is handled at view level
    @convocations = @station.convocations.newer.limit(5)
    @interventions = @station.interventions.newer.limit(5)
    @items = Item.expirings(30, @station.id).limit(5)
    @messages = current_user.messages.unread
  end

end
