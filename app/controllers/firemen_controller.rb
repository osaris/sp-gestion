class FiremenController < BackController
  
  navigation(:firemen)
  
  before_filter :load_fireman, :except => [:index, :new, :create]  
  
  def index
    current_navigation(:firemen_list)    
    @firemen = @station.firemen.paginate(:page => params[:page], :order => 'lastname')
    # @firemen_stats_status = Fireman::count_status(@station.id)
    # @firemen_stats_grade = Fireman::count_grade(@station.id)    
  end
  
  def show
  end
  
  def new
    current_navigation(:firemen_new)
    @fireman = @station.firemen.new
  end
  
  def create
    current_navigation(:firemen_new)
    @fireman = @station.firemen.new(params[:fireman])
    if(@fireman.save)
      render(:action => :show)
    else
      render(:action => :new)
    end
  end
  
  def edit
  end
  
  def update
    if @fireman.update_attributes(params[:fireman])
      render(:action => :show)
    else
      render(:action => :edit)
    end
  end
  
  def destroy
    @fireman.destroy
    redirect_to(firemen_path)
  end
  
  private
  
  def load_fireman
    @fireman = @station.firemen.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    redirect_to(firemen_path)
  end
  
end
