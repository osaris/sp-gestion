# -*- encoding : utf-8 -*-
class GroupsController < BackController

  before_action :require_not_demo
  before_action :load_group, :only => [:show, :edit, :update, :destroy]
  before_action :load_users, :except => [:index, :destroy]
  before_action :load_resources, :except => [:index, :destroy]
  before_action :check_ownership

  def index
    @groups = @station.groups
                      .page(params[:page]) \
                      .order('name')
  end

  def show
  end

  def new
    @group = @station.groups.new
  end

  def create
    @group = @station.groups.new(group_params)
    if(@group.save)
      flash[:success] = "Le groupe a été créé."
      redirect_to(@group)
    else
      render(:action => :new)
    end
  end

  def edit
  end

  def update
    if @group.update_attributes(group_params)
      flash[:success] = "Le groupe a été mis à jour."
      redirect_to(@group)
    else
      render(:action => :edit)
    end
  end

  def destroy
    @group.destroy
    flash[:success] = "Le groupe a été supprimé."
    redirect_to(groups_path)
  end

  private

  def load_group
    @group = @station.groups.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "Le groupe n'existe pas."
    redirect_to(groups_path)
  end

  def load_users
    @users = @station.users
                     .joins('LEFT OUTER JOIN groups ON (groups.id = users.group_id)')
  end

  def load_resources
    @resources = Resource.all
  end

  def group_params
    params.require(:group).permit(:name, user_ids: [], permissions_attributes: [
                                  :id, :resource_id, :can_read, :can_create,
                                  :can_update, :can_destroy])
  end
end
