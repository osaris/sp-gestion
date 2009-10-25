class ConfirmationsController < BackController
  
  skip_before_filter :require_user
  before_filter :require_no_user

  def create
    @user = @station.users.find_using_perishable_token(params[:id])
    if @user.nil? or @user.confirmed?
      flash[:error] = "Compte inexistant ou inactif."
      redirect_to(login_path)      
    else
      @user.confirm!
      UserSession.create(@user)
      redirect_to(root_back_path)
    end
  end
  
end
