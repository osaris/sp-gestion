# -*- encoding : utf-8 -*-
class InterventionsController < BackController

  before_filter :load_intervention, :only => [:show, :edit, :update, :destroy]
  before_filter :load_vehicles, :load_firemen, :load_cities, :load_subtypes, 
                :only => [:new, :create, :edit, :update]
  before_filter :load_map, :only => [:show]

  def index
    @interventions = @station.interventions.paginate(
      :page => params[:page], 
      :include => [:vehicles, {:fireman_interventions => [:fireman]}],
      :order => 'interventions.start_date DESC'
    )
  end

  def show
  end

  def new
    @intervention = @station.interventions.new
    set_participants
  end

  def create
    @intervention = @station.interventions.new(params[:intervention])
    if(@intervention.save)
      flash[:success] = "L'intervention a été créée."
      redirect_to(@intervention)
    else
      set_participants
      render(:action => :new)
    end
  end

  def edit
    if not @intervention.editable?
      flash[:error] = "Vous ne pouvez pas éditer cette intervention car les grades ont évolué."
      redirect_to(@intervention)
    else
      set_participants
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
      if @intervention.update_attributes(params[:intervention])
        flash[:success] = "L'intervention a été mise à jour."
        redirect_to(@intervention)
      else
        set_participants
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
    @current_year = params[:new_year]
    redirect_to(interventions_stats_path(@current_year, params[:type]))
  end

  def stats
    last_intervention = @station.interventions.latest.first
    if last_intervention.blank?
      flash[:warning] = "Il faut au moins une intervention pour avoir des statistiques."
      redirect_to(interventions_path)
    else
      @current_year = (params[:year] || last_intervention.start_date.year)
      @min_year, @max_year = Intervention::min_max_year(@station)
      @data = Intervention.send("stats_#{params[:type]}", @station, @current_year)
     
      if ["by_type", "by_subtype", "by_city", "by_vehicle"].include?(params[:type])
        @sum = @data.inject(0) { |sum, stat| sum ? sum+stat[1] : stat[1] }
      elsif ["by_month", "by_hour"].include?(params[:type])
        @sum = @data.sum
      elsif params[:type] == "map"
        @sum = @data.length

        @map = GoogleMap::Map.new
        @data.each do |intervention|
          unless intervention.geocode.nil?
            html = render_to_string(:partial => "intervention_map",
                                    :locals => { :intervention => intervention})
            @map.markers << GoogleMap::Marker.new(:map => @map,
                                                  :lat => intervention.geocode.latitude,
                                                  :lng => intervention.geocode.longitude,
                                                  :open_infoWindow => false,
                                                  :html => html)
          end
        end
      end
    end
  end

  private

  def load_intervention
    # Rails can't load all stuff in 1 SQL query because we use has_many :through
    @intervention = @station.interventions.includes(:vehicles, {:fireman_interventions => [:fireman]}) \
                                          .find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "L'intervention n'existe pas."
    redirect_to(interventions_path)
  end

  def load_vehicles
    @vehicles = @station.vehicles
  end

  def load_firemen
    @firemen = @station.firemen.where(:status => Fireman::STATUS['Actif']).order_by_grade_and_lastname
  end

  def load_cities
    @cities = Intervention::cities(@station)
  end

  def load_subtypes
    @subtypes = Intervention::subtypes(@station)
  end

  def set_participants
    @participants = Hash.new
    @intervention.firemen.each do |f|
      @participants[f.id] = true
    end
  end

  def load_map
    unless @intervention.geocode.blank?
      @map = GoogleMap::Map.new
      @map.center = GoogleMap::Point.new(@intervention.geocode.latitude,
                                         @intervention.geocode.longitude)
      @map.zoom = 14
      @map.markers << GoogleMap::Marker.new(:map => @map,
                                            :lat => @intervention.geocode.latitude,
                                            :lng => @intervention.geocode.longitude,
                                            :open_infoWindow => false)
    end
  end
end
