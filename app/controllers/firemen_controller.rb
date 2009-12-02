class FiremenController < BackController
  
  navigation(:firemen)
  
  before_filter :load_fireman, :except => [:index, :new, :create]  
  
  def index
    @firemen = @station.firemen.paginate(:page => params[:page], :order => 'firemen.grade DESC, firemen.lastname ASC')
  end
  
  def show
  end
  
  def new
    @fireman = @station.firemen.new
  end
  
  def create
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
    if @fireman.destroy
      redirect_to(firemen_path)
    else
      flash.now[:error] = @fireman.errors.full_messages
      render(:action => :show)
    end
  end
  
  private
  
  def load_fireman
    @fireman = @station.firemen.find(params[:id], :include => :convocations)
   rescue ActiveRecord::RecordNotFound
    redirect_to(firemen_path)
  end
  
end
