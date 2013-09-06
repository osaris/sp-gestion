# -*- encoding : utf-8 -*-
class VehiclesController < BackController

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
    @vehicle = @station.vehicles.new(vehicle_params)
    if(@vehicle.save)
      flash[:success] = "Le véhicule a été créé."
      redirect_to(@vehicle)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @vehicle.update_attributes(vehicle_params)
      flash[:success] = "Le véhicule a été mis à jour."
      redirect_to(@vehicle)
    else
      render(:action => :edit)
    end
  end

  def destroy
    if @vehicle.destroy
      flash[:success] = "Le véhicule a été supprimé."
      redirect_to(vehicles_path)
    else
      flash[:error] = @vehicle.errors.full_messages.join("")
      redirect_to(@vehicle)
    end
  end

  private

  def load_vehicle
    @vehicle = @station.vehicles.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "Le véhicule n'existe pas."
    redirect_to(vehicles_path)
  end

  def vehicle_params
    parameters.require(:vehicle).permit(:name, :rem, :date_approval,
                                        :date_check, :date_review,
                                        :vehicle_photo, :remove_vehicle_photo)
  end
end
