class NewsletterMailer < ActionMailer::Base
  
  def activation_instructions(newsletter)
    setup(newsletter.email)
    subject("Disponibilité de SP-Gestion")
    body(:newsletter => newsletter)
  end  
  
  private

  def setup(email)
    from("SP-Gestion.fr <pas_de_reponse@sp-gestion.fr>")
    recipients(email)
    sent_on(Time.now)
  end

end
