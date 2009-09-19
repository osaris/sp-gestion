class NewslettersController < ApplicationController
  
  def create
    @newsletter = Newsletter.new(params[:newsletter])
    if @newsletter.save
      flash.now[:notice] = "Nous avons envoyé un email sur votre adresse #{@newsletter.email} afin de valider votre inscription."
    else
      flash.now[:error] = "L'adresse email ne semble pas valide ou est déjà abonnée !"
    end
    render('pages/home')
  end
  
  def activate
    @newsletter = Newsletter.find_by_activation_key(params[:id])
    if @newsletter
      @newsletter.activate!
      flash.now[:notice] = "Nous avons validé votre adresse email. Vous recevrez un email dès que SP-Gestion sera disponible."
      render('pages/home')      
    else
      redirect_to(home_page_path)
    end
  end
  
end
