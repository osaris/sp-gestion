# -*- encoding : utf-8 -*-
class AccountsController < BackController

  before_filter :check_ownership

  def edit
    @users = @station.users.confirmed.where(["users.id != ?", @station.owner_id])
  end

  def update_owner
    if @station.update_owner(params[:station][:owner_id])
      flash[:success] = "Le propriétaire du compte a bien été changé !"
    else
      flash[:error] = "Erreur"
    end
    redirect_to(root_back_url)
  end

  def update_logo
    if @station.update_attributes(params[:station])
      flash[:success] = "Le logo a bien été mis à jour !"
    else
      flash[:error] = "Erreur lors de la mise à jour du logo, le fichier doit être au format png, jpg ou gif."
    end
    redirect_to(edit_account_url)
  end

  def destroy
    @station.delay.destroy
    # FIXME because we can't rewrite subdomain easily
    redirect_to("http://www.#{BASE_URL}/bye")
  end

end
