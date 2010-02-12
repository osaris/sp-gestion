class ApplicationMailer < ActionMailer::Base
  
  protected

  def setup(email)
    default_url_options[:host] = "www.#{BASE_URL}"
    from("SP-Gestion.fr <pas_de_reponse@sp-gestion.fr>")
    recipients(email)
    sent_on(Time.now)
  end
  
end