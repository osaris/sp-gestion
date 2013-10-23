# -*- encoding : utf-8 -*-
class FiremenController < BackController

  helper(:interventions)

  before_action :load_fireman, :except => [:index, :new, :create, :facebook, :resigned, :trainings]
  before_action :load_tags, :only => [:new, :create, :edit, :update]

  def index
    @firemen = @station.firemen
                       .page(params[:page]) \
                       .not_resigned \
                       .order('firemen.grade DESC, firemen.lastname ASC')
  end

  def show
  end

  def new
    @fireman = @station.firemen.new
  end

  def create
    @fireman = @station.firemen.new(fireman_params)
    if(@fireman.save)
      flash[:success] = "La personne a été créée."
      redirect_to(@fireman)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @fireman.update_attributes(fireman_params)
      flash[:success] = "La personne a été mise à jour."
      flash[:warning] = @fireman.warnings
      redirect_to(@fireman)
    else
      render(:action => :edit)
    end
  end

  def destroy
    if @fireman.destroy
      flash[:success] = "La personne a été supprimée."
      redirect_to(firemen_path)
    else
      flash[:error] = @fireman.errors.full_messages.join("")
      redirect_to(@fireman)
    end
  end

  def facebook
    @firemen = @station.firemen.not_resigned.order_by_grade_and_lastname
  end

  def resigned
    @firemen = @station.firemen \
                       .page(params[:page]) \
                       .resigned \
                       .order_by_grade_and_lastname \
                       .order('firemen.grade DESC, firemen.lastname ASC')
    render(:action => :index)
  end

  def stats_change_year
    redirect_to(firemen_stats_path(@fireman, params[:new_year], params[:type]))
  end

  def stats
    @years_stats = @fireman.years_stats
    if @years_stats.empty?
      flash[:error] = "Les données actuelles ne permettent pas d'établir des statistiques."
      redirect_to(@fireman)
    elsif !@years_stats.include?(params[:year].to_i)
      redirect_to(firemen_stats_path(@fireman, @years_stats.first, params[:type]))
    elsif !['convocations','interventions'].include?(params[:type])
      redirect_to(firemen_stats_path(@fireman, params[:year], 'convocations'))
    else
      @data = @fireman.send("stats_#{params[:type]}", @station, params[:year])
    end
  end

  def trainings
    @firemen = @station.firemen.not_resigned.order_by_grade_and_lastname
    @trainings = @station.trainings.order_by_short_name
    @fireman_trainings = FiremanTraining.all_to_hash(@station.id)
  end

  private

  def load_fireman
    @fireman = @station.firemen.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La personne n'existe pas."
    redirect_to(firemen_path)
  end

  def load_tags
    @tags = Fireman.distinct_tags(@station).to_json
  end

  def fireman_params
    params.require(:fireman).permit(:firstname, :lastname, :status, :birthday,
                                    :rem, :checkup, :email, :passeport_photo,
                                    :passeport_photo_cache,
                                    :remove_passeport_photo, :regimental_number,
                                    :incorporation_date, :resignation_date,
                                    :checkup_truck, :tag_list,
                                    :validate_grade_update,
                                    grades_attributes: [:id, :kind, :date])
  end
end