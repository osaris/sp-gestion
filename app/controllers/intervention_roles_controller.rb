# -*- encoding : utf-8 -*-
class InterventionRolesController < BackController

  before_filter :load_intervention_role, :except => [:index, :new, :create]

  def index
    @intervention_roles = @station.intervention_roles.paginate(:page => params[:page], :order => 'name, short_name')
  end

  def show
  end

  def new
    @intervention_role = @station.intervention_roles.new
  end

  def create
    @intervention_role = @station.intervention_roles.new(params[:intervention_role])
    if(@intervention_role.save)
      flash[:success] = "Le rôle a été créé."
      redirect_to(@intervention_role)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @intervention_role.update_attributes(params[:intervention_role])
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

end
