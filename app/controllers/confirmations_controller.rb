class ConfirmationsController < BackController

  layout('login')

  skip_before_action :require_user
  before_action :require_no_user

  before_action :load_user

  def edit
  end

  def update
    if @user.confirm!(params[:user][:password], params[:user][:password_confirmation])
      flash[:success] = render_to_string(:partial => "welcome").html_safe if @user.owner?
      redirect_to(root_back_path)
    else
      render(:action => :edit)
    end
  end

  private

  def load_user
    # find without limit on perishable token
    @user = @station.users.find_using_perishable_token(params[:id], 0)
    if @user.nil? or @user.confirmed?
      flash[:error] = "Compte inexistant ou inactif."
      redirect_to(login_path)
    end
  end
end
