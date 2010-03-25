# Newsletter relative notifications
class NewsletterMailer < ApplicationMailer
  
  def activation_instructions(newsletter)
    setup(newsletter.email)
    subject("Disponibilité de SP-Gestion")

    content_type("multipart/alternative")

    activation_url = activate_newsletter_url(newsletter)

    part "text/plain" do |plain_part|
      plain_part.body = render_message("activation_instructions.plain", :activation_url => activation_url)
      plain_part.transfer_encoding = "base64"
    end

    part "text/html" do |html_part|
      html_part.body = render_message("activation_instructions.html", :activation_url => activation_url)
      html_part.transfer_encoding = "base64"
    end
  end
  
  def boost_activation(newsletter)
    setup(newsletter.email)
    subject("Disponibilité de SP-Gestion")

    content_type("multipart/alternative")

    activation_url = activate_newsletter_url(newsletter)

    part "text/plain" do |plain_part|
      plain_part.body = render_message("boost_activation.plain", :activation_url => activation_url)
      plain_part.transfer_encoding = "base64"
    end

    part "text/html" do |html_part|
      html_part.body = render_message("boost_activation.html", :activation_url => activation_url)
      html_part.transfer_encoding = "base64"
    end    
  end

end
