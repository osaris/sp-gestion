class DaybooksController < BackController

  authorize_resource

  before_action :load_daybook, :except => [:index, :new, :create]

  def index
    @daybooks = @station.daybooks
                        .page(params[:page])
                        .order('created_at')
  end

  def show
  end

  def new
    @daybook = @station.daybooks.new
  end

  def create
    @daybook = @station.daybooks.new(daybook_params)
    if @daybook.save
      flash[:success] = "La main courante a été créée."
      redirect_to(@daybook)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @daybook.update_attributes(daybook_params)
      flash[:success] = "La main courante a été mise à jour."
      redirect_to(@daybook)
    else
      render(:action => :edit)
    end
  end

  def destroy
    if @daybook.destroy
      flash[:success] = "La main courante a été supprimée."
      redirect_to(daybooks_path)
    else
      flash[:error] = @daybook.errors.full_messages.join("")
      redirect_to(@daybook)
    end
  end

  private

  def load_daybook
    @daybook = @station.daybooks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "La main courante n'existe pas."
    redirect_to(daybooks_path)
  end

  def daybook_params
    params.require(:daybook).permit(:text, :frontpage)
  end
end
