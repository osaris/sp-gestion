class DashboardController < BackController

  helper(:interventions)

  def index
    # authorization is handled at view level
    @daybooks = @station.daybooks.frontpage
    @conversations = current_user.mailbox.inbox.limit(5)
    @convocations = @station.convocations.newer.limit(5)
    @interventions = @station.interventions.newer.limit(5)
    @items = Item.expirings(30, @station.id).limit(5)
  end

end
