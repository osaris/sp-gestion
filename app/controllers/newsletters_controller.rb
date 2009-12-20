class NewslettersController < FrontController
  
  def create
    @newsletter = Newsletter.new(params[:newsletter])
    if @newsletter.save
      flash.now[:notice] = "Nous avons envoyé un email sur votre adresse #{@newsletter.email} afin de valider votre inscription à notre avant-première."
    else
      flash.now[:error] = "L'adresse email ne semble pas valide ou est déjà abonnée !"
    end
    render('pages/home')
  end
  
  def activate
    @newsletter = Newsletter.find_by_activation_key(params[:id])
    if @newsletter
      @newsletter.activate!
      flash.now[:notice] = render_to_string(:partial => "activate")
      render('pages/home')
    else
      redirect_to(home_path)
    end
  end
  
end
