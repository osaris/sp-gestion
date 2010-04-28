class AccountsController < BackController
  
  before_filter :check_ownership
  
  def edit
    @users = @station.users.confirmed.find(:all, :conditions => ["users.id != ?", @station.owner_id])
  end
  
  def update
    if @station.update_owner(params[:station][:owner_id])
      flash[:success] = "Le propriétaire du compte a bien été changé !"
    else
      flash[:error] = "Erreur"
    end
    redirect_to(root_back_url)
  end
  
  def destroy
    @station.destroy
    # because we can't rewrite subdomain easily
    redirect_to("http://www.#{BASE_URL}/bye")
  end
  
end