# -*- encoding : utf-8 -*-
class ProfilesController < BackController

  before_filter :require_not_demo
  before_filter :load_user

  def edit
  end

  def update
    if @user.update_profile(params)
      flash[:success] = "Le profil a été mis à jour. Si vous avez changé votre adresse email
                         vous devez d'abord cliquer sur le lien envoyé par email à votre nouvelle
                         adresse pour que celle-ci remplace votre adresse actuelle."
      redirect_to(profile_path)
    else
      render(:action => :edit)
    end
  end

  private

  def load_user
    @user = current_user
  end

end
