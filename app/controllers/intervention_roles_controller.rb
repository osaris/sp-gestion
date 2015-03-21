class InterventionRolesController < BackController

  authorize_resource

  before_action :load_intervention_role, :except => [:index, :new, :create]

  def index
    @intervention_roles = @station.intervention_roles
                                  .page(params[:page])
                                  .order('name, short_name')
  end

  def show
  end

  def new
    @intervention_role = @station.intervention_roles.new
  end

  def create
    @intervention_role = @station.intervention_roles.new(intervention_role_params)
    if @intervention_role.save
      flash[:success] = "Le rôle a été créé."
      redirect_to(@intervention_role)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @intervention_role.update_attributes(intervention_role_params)
      flash[:success] = "Le rôle a été mis à jour."
      redirect_to(@intervention_role)
    else
      render(:action => :edit)
    end
  end

  def destroy
    if @intervention_role.destroy
      flash[:success] = "Le rôle a été supprimé."
      redirect_to(intervention_roles_path)
    else
      flash[:error] = @intervention_role.errors.full_messages.join("")
      redirect_to(@intervention_role)
    end
  end

  private

  def load_intervention_role
    @intervention_role = @station.intervention_roles.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "Le rôle n'existe pas."
    redirect_to(intervention_roles_path)
  end

  def intervention_role_params
    params.require(:intervention_role).permit(:name, :short_name)
  end
end
