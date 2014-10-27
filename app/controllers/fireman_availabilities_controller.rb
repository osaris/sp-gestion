# -*- encoding : utf-8 -*-
class FiremanAvailabilitiesController < BackController

  before_action :load_fireman

  def index
    respond_to do |format|
      format.html
      format.json do
        start_date = DateTime.parse(params[:start])
        end_date = DateTime.parse(params[:end])
        @availabilities = @fireman.fireman_availabilities.where(:availability => start_date..end_date)
      end
    end
  end

  def create
    @fireman_availability = @station.fireman_availabilities.new(fireman_availability_params)

    respond_to do |format|
      if @fireman_availability.save
        format.json { render json: @fireman_availability }
      else
        format.json { render json: @fireman_availability.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_all
    FiremanAvailability::create_all(@station,
                                    @fireman.id,
                                    params[:fireman_availability][:availability])
    head :ok
  end

  def destroy
    respond_to do |format|
      format.json do
        begin
          @station.fireman_availabilities.destroy(params[:id])
          render :nothing => true, :status => :ok
        rescue ActiveRecord::RecordNotDestroyed
          render :nothing => true, :status => :unprocessable_entity
        end
      end
    end
  end

  def destroy_all
    FiremanAvailability::destroy_all(@fireman.id,
                                     params[:fireman_availability][:availability])
    head :ok
  end

  private

  def load_fireman
    @fireman = @station.firemen.find(params[:fireman_id])
    if @fireman.status != Fireman::STATUS['Actif']
      flash[:error] = "La disponibilité n'est disponible que pour les hommes actifs."
      redirect_to(fireman_path(@fireman))
    end
  end

  def fireman_availability_params
    params[:fireman_availability][:availability] = DateTime.parse(params[:fireman_availability][:availability])
    params.require(:fireman_availability).permit(:availability, :fireman_id)
  end
end
