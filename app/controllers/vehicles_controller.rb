class VehiclesController < BackController
  
  set_tab(:vehicles)
  
  before_filter :load_vehicle, :except => [:index, :new, :create]  
  
  def index
    @vehicles = @station.vehicles.paginate(:page => params[:page], :order => 'name')
  end
  
  def show
  end
  
  def new
    @vehicle = @station.vehicles.new
  end
  
  def create
    @vehicle = @station.vehicles.new(params[:vehicle])
    if(@vehicle.save)
      render(:action => :show)
    else
      render(:action => :new)
    end
  end
  
  def edit
  end
  
  def update
    if @vehicle.update_attributes(params[:vehicle])
      render(:action => :show)
    else
      render(:action => :edit)
    end    
  end
  
  def destroy
    @vehicle.destroy
    redirect_to(vehicles_path)    
  end
  
  private
  
  def load_vehicle
    @vehicle = @station.vehicles.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    redirect_to(vehicles_path)    
  end
  
end
