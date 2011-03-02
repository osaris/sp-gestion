# -*- encoding : utf-8 -*-
class UserSessionsController < BackController

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:destroy]
  
  layout('login')
  
  navigation(:user_sessions)
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = @station.user_sessions.new(params[:user_session])
    if @user_session.save
      redirect_to(root_back_path)
    else
      flash.now[:error] = "Erreur dans votre adresse email ou votre mot de passe."
      render(:action => :new)
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:success] = "Vous êtes désormais déconnecté."
    redirect_to(login_path)
  end  
  
end
