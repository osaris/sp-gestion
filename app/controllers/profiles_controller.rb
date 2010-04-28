class ProfilesController < BackController
  
  before_filter :load_user
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Le mot de passe a bien été changé."
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
