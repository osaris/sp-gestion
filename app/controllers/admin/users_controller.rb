class Admin::UsersController < Admin::ResourcesController

  def boost_activation
    user = User.find(params[:id])
    if user.boost_activation
      flash[:success] = "Relance envoyée !"
      redirect_to(:action => :index)
    else
      flash[:error] = "Déjà activé !"
      redirect_to(:back)
    end
  end

end
