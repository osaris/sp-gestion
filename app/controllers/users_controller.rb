# -*- encoding : utf-8 -*-
class UsersController < BackController

  before_filter :load_user, :only => [:destroy]
  before_filter :check_ownership

  def index
    @users = @station.users.paginate(:page => params[:page], :order => 'email')
  end

  def new
    @user = @station.users.new
  end

  def create
    @user = @station.users.new(params[:user])
    @user.cooptation = true
    if(@user.save)
      @user.deliver_cooptation_instructions!
      flash[:success] = "L'invitation a été envoyée avec succès."
      redirect_to(users_path)
    else
      render(:action => :new)
    end
  end

  def destroy
    if @user.id == @station.owner_id
      flash[:warning] = render_to_string(:partial => 'users/owner_instructions',
                                       :layout => false)
    else
      @user.destroy
      flash[:success] = "L'utilisateur a bien été supprimé."
    end
    redirect_to(users_path)
  end

  private

  def load_user
    @user = @station.users.find(params[:id])
   rescue ActiveRecord::RecordNotFound
    flash[:error] = "L'utilisateur n'existe pas."
    redirect_to(users_path)
  end

end
