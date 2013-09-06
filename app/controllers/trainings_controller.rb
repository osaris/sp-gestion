# -*- encoding : utf-8 -*-
class TrainingsController < BackController

  before_filter :load_training, :except => [:index, :new, :create]

  def index
    @trainings = @station.trainings.paginate(:page => params[:page], :order => 'name, short_name')
  end

  def show
  end

  def new
    @training = @station.trainings.new
  end

  def create
    @training = @station.trainings.new(training_params)
    if(@training.save)
      flash[:success] = "La formation a été créée."
      redirect_to(@training)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @training.update_attributes(training_params)
      flash[:success] = "La formation a été mise à jour."
      redirect_to(@training)
    else
      render(:action => :edit)
    end
  end

  def destroy
    if @training.destroy
      flash[:success] = "La formation a été supprimée."
      redirect_to(trainings_path)
    else
      flash[:error] = @training.errors.full_messages.join("")
      redirect_to(@training)
    end
  end

  private

  def load_training
    @training = @station.trainings.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "La formation n'existe pas."
    redirect_to(trainings_path)
  end

  def trainings_params
    parameters.require(:training).permit(:name, :short_name, :description)
  end
end