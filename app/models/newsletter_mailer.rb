class NewsletterMailer < ActionMailer::Base
  
  def activation_instructions(newsletter)
    setup(newsletter.email)
    subject("Disponibilité de SP-Gestion")

    content_type    "multipart/alternative"

    part "text/html" do |p|
      p.body = render_message("activation_instructions.html", :newsletter => newsletter)
    end

    part "text/plain" do |p|
      p.body = render_message("activation_instructions.plain", :newsletter => newsletter)
      p.transfer_encoding = "base64"
    end
  end  
  
  private

  def setup(email)
    default_url_options[:host] = "www.#{BASE_URL}"
    from("SP-Gestion.fr <pas_de_reponse@sp-gestion.fr>")
    recipients(email)
    sent_on(Time.now)
  end

end
