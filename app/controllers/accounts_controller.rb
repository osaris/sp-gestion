class AccountsController < BackController

  before_action :require_not_demo
  before_action :check_ownership

  def edit
    @users = @station.users.confirmed.where(["users.id != ?",
                                             @station.owner_id])
  end

  def update_owner
    if @station.update_owner(params[:station][:owner_id])
      flash[:success] = "Le propriétaire du compte a bien été changé !"
    else
      flash[:error] = "Erreur"
    end
    redirect_to(root_back_url)
  end

  def update_settings
    if @station.update_attributes(station_params)
      flash[:success] = "Les paramètres ont bien été mis à jour !"
    else
      flash[:error] = "Erreur lors de la mise à jour !"
    end
    redirect_to(edit_account_url)
  end

  def destroy
    DestroyStationJob.perform_later(@station)
    redirect_to(bye_url(:subdomain => 'www'))
  end

  private

  def station_params
    params.require(:station).permit(:name, :url, :logo, :remove_logo,
                                    :logo_cache,
                                    :interventions_number_size,
                                    :interventions_number_per_year)
  end

end
