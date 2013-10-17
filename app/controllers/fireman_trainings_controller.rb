class FiremanTrainingsController < BackController

  before_action :load_fireman, :except => [:index]
  before_action :load_fireman_training, :except => [:index, :new, :create]
  before_action :load_trainings, :except => [:index, :show, :destroy]

  def index
    @fireman = @station.firemen.includes(:fireman_trainings => [:training]) \
                               .order('trainings.short_name ASC') \
                               .find(params[:fireman_id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La personne n'existe pas."
    redirect_to(firemen_path)
  end

  def show
  end

  def new
    @fireman_training = @fireman.fireman_trainings.new
  end

  def create
    @fireman_training = @fireman.fireman_trainings.new(fireman_training_params)
    if(@fireman_training.save)
      flash[:success] = "La formation a été ajoutée."
      redirect_to([@fireman, @fireman_training])
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @fireman_training.update_attributes(fireman_training_params)
      flash[:success] = "La formation a été mise à jour."
      redirect_to([@fireman, @fireman_training])
    else
      render(:action => :edit)
    end
  end

  def destroy
    if @fireman_training.destroy
      flash[:success] = "La formation a été supprimée."
      redirect_to(fireman_fireman_trainings_path(@fireman))
    else
      flash[:error] = @fireman.errors.full_messages.join("")
    redirect_to([@fireman, @fireman_training])
    end
  end

  private

  def load_fireman
    @fireman = @station.firemen.find(params[:fireman_id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La personne n'existe pas."
    redirect_to(firemen_path)
  end

  def load_fireman_training
    @fireman_training = @fireman.fireman_trainings.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La formation n'existe pas."
    redirect_to(fireman_fireman_trainings_path(@fireman))
  end

  def load_trainings
    @trainings = @station.trainings.collect { |training| [ training.short_name, training.id ] }
  end

  def fireman_training_params
    params.require(:fireman_training).permit(:training_id, :achieved_at, :rem)
  end
end