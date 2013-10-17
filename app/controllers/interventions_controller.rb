# -*- encoding : utf-8 -*-
class InterventionsController < BackController

  before_action :load_intervention, :only => [:show, :edit, :update, :destroy]
  before_action :load_vehicles, :load_cities, :load_subkinds, \
                :only => [:new, :create, :edit, :update]
  before_action :process_fireman_interventions_attrs, :only => [:create, :update]


  def index
    @interventions = @station.interventions
                             .page(params[:page])
                             .includes(:vehicles, {:fireman_interventions => [:fireman]})
                             .order('interventions.start_date DESC')
  end

  def show
  end

  def new
    @intervention = @station.interventions.new
  end

  def create
    @intervention = @station.interventions.new(intervention_params)
    if(@intervention.save)
      flash[:success] = "L'intervention a été créée."
      redirect_to(@intervention)
    else
      render(:action => :new)
    end
  end

  def edit
    if not @intervention.editable?
      flash[:error] = "Vous ne pouvez pas éditer cette intervention car les grades ont évolué."
      redirect_to(@intervention)
    end
  end

  def update
    if not @intervention.editable?
      flash[:error] = "Vous ne pouvez pas éditer cette intervention car les grades ont évolué."
      redirect_to(@intervention)
    else
      # overwrite params because browser doesn't send array if no checkbox are selected
      # and rails omit them in this case !
      params[:intervention][:vehicle_ids] ||= []
      params[:intervention][:fireman_ids] ||= []
      if @intervention.update_attributes(intervention_params)
        flash[:success] = "L'intervention a été mise à jour."
        redirect_to(@intervention)
      else
        render(:action => :edit)
      end
    end
  end

  def destroy
    @intervention.destroy
    flash[:success] = "L'intervention a été supprimée."
    redirect_to(interventions_path)
  end

  def stats_change_year
    redirect_to(interventions_stats_path(params[:new_year], params[:type]))
  end

  def stats
    last_intervention = @station.interventions.latest.first
    if last_intervention.blank?
      flash[:warning] = "Il faut au moins une intervention pour avoir des statistiques."
      redirect_to(interventions_path)
    else
      @years_stats = Intervention::years_stats(@station)
      if !@years_stats.include?(params[:year].to_i)
        redirect_to(interventions_stats_path(@years_stats.first, params[:type]))
      elsif !['by_type','by_subkind','by_city','by_vehicle','by_month','by_hour','map'].include?(params[:type])
        redirect_to(interventions_stats_path(params[:year], 'by_type'))
      else
        @data, @sum = Intervention::stats(self, @station, params[:type], params[:year])
      end
    end
  end

  private

  def load_intervention
    # Rails can't load all stuff in 1 SQL query because we use has_many :through
    @intervention = @station.interventions.includes(:vehicles, {:fireman_interventions => [:fireman, :intervention_role]}) \
                                          .find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "L'intervention n'existe pas."
    redirect_to(interventions_path)
  end

  def load_vehicles
    @vehicles = @station.vehicles
  end

  def load_cities
    @cities = Intervention::cities(@station)
  end

  def load_subkinds
    @subkinds = Intervention::subkinds(@station)
  end

  def process_fireman_interventions_attrs
    unless params[:intervention][:fireman_interventions_attributes].blank?
      params[:intervention][:fireman_interventions_attributes].values.each do |fi_attr|
        fi_attr[:_destroy] = (fi_attr[:enable] != '1')
      end
    end
  end

  def intervention_params
    params.require(:intervention).permit(:kind, :number, :start_date, :end_date,
                                         :place, :rem, :city, :subkind,
                                         vehicle_ids: [],
                                         fireman_interventions_attributes: [
                                            :id, :enable, :intervention_role_id,
                                            :fireman_id, :_destroy])
  end
end
