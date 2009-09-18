class NewslettersController < ApplicationController
  
  def create
    @newsletter = Newsletter.new(params[:newsletter])
    if @newsletter.save
      flash.now[:notice] = "Merci pour votre inscription, un email vous a été envoyé pour confirmer votre inscription."
    else
      flash.now[:error] = "L'adresse email ne semble pas valide ou est déjà abonnée !"
    end
    render('pages/home')
  end
  
  def activate
    newsletter = Newsletter.find_by_activation_code(params[:id])
    newsletter.activate!
   rescue ActiveRecord::RecordNotFound
    render('pages/home')
  end
  
end
