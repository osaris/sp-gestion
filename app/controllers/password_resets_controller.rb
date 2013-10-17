class PasswordResetsController < BackController

  skip_before_action :require_user
  before_action :require_not_demo
  before_action :require_no_user
  before_action :load_user_using_perishable_token, :only => [:edit, :update]

  layout('login')

  def new
  end

  def create
    @user = @station.users.where(:email => params[:email]).first
    if @user and @user.confirmed?
      @user.deliver_password_reset_instructions!
      flash.now[:warning] = "Les instructions pour recevoir votre nouveau mot de passe vous ont été transmises par email."
    else
      flash.now[:error] = "Aucun utilisateur trouvé avec cette adresse email."
    end
    render(:action => :new)
  end

  def edit
  end

  def update
    if @user.reset_password!(params[:user][:password], params[:user][:password_confirmation])
      flash[:success] = "Mot de passe mis à jour avec succès."
      UserSession.create(@user)
      redirect_to(root_back_url)
    else
      render(:action => :edit)
    end
  end

  private

  def load_user_using_perishable_token
    @user = @station.users.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "Nous sommes désolés mais nous n'arrivons pas à trouver votre compte. " +
                       "Essayez de copier/coller l'adresse de changement de mot de passe depuis " +
                       "votre email ou recommencez la procédure de changement de mot de passe."
      redirect_to(login_url)
    end
  end

end
