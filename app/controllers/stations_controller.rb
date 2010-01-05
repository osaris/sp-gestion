class StationsController < FrontController
  
  def new
    @station = Station.new
  end
  
  def create
    @station = Station.new(params[:station])
    @user = @station.users.build(params[:user])
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
    search = "%#{params[:name]}%"
    station = Station.find(:first, :conditions => ["(url LIKE ?) OR (name LIKE ?)", search, search])
    render(:update) do |page|
      if station.nil?
        page[:name_warning].hide
      else
        page[:name_warning].show
      end
    end
  end
end