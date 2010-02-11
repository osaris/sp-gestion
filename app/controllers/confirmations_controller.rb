class ConfirmationsController < BackController
  
  skip_before_filter :require_user
  before_filter :require_no_user

  def create
    # find without limit on perishable token
    @user = @station.users.find_using_perishable_token(params[:id], 0)
    if @user.nil? or @user.confirmed?
      flash[:error] = "Compte inexistant ou inactif."
      redirect_to(login_path)
    else
      @user.confirm!
      UserSession.create(@user)
      flash[:success] = render_to_string(:partial => "welcome")
      redirect_to(root_back_path)
    end
  end
  
end
