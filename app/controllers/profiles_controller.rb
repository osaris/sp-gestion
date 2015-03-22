class ProfilesController < BackController

  before_action :require_not_demo
  before_action :load_user
  before_action :load_resources

  def edit
  end

  def update
    if @user.update_profile(user_params)
      if user_params[:new_email_tmp].blank?
        flash[:success] = "Votre profil a bien été mis à jour."
      else
        flash[:success] = "Vous devez d'abord cliquer sur le lien envoyé par email
                           à votre nouvelle adresse pour que celle-ci remplace
                           votre adresse actuelle."
      end
      redirect_to(profile_path)
    else
      render(:action => :edit)
    end
  end

  private

  def load_resources
    @resources = Resource.all
  end

  def load_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :new_email_tmp)
  end
end
