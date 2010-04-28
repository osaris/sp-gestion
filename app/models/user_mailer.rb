# User relative notifications
class UserMailer < ApplicationMailer
  
  def confirmation_instructions(user)
    setup(user)
    subject("Activation de votre compte SP-Gestion.fr")

    confirmation_url = edit_confirmation_url(user.perishable_token)

    content_type("multipart/alternative")
    part "text/plain" do |plain_part|
      plain_part.body = render_message("confirmation_instructions.plain", :confirmation_url => confirmation_url)
      plain_part.transfer_encoding = "base64"
    end

    part "text/html" do |html_part|
      html_part.body = render_message("confirmation_instructions.html", :confirmation_url => confirmation_url)
      html_part.transfer_encoding = "base64"
    end
  end
  
  def cooptation_instructions(user)
    setup(user)
    subject("Invitation à rejoindre SP-Gestion.fr")

    confirmation_url = edit_confirmation_url(user.perishable_token)
    station_url = user.station.url

    content_type("multipart/alternative")
    part "text/plain" do |plain_part|
      plain_part.body = render_message("cooptation_instructions.plain", :station_url => station_url, :confirmation_url => confirmation_url)
      plain_part.transfer_encoding = "base64"
    end

    part "text/html" do |html_part|
      html_part.body = render_message("cooptation_instructions.html", :station_url => @station_url, :confirmation_url => confirmation_url)
      html_part.transfer_encoding = "base64"
    end    
  end
  
  def password_reset_instructions(user)
    setup(user)
    subject("Modification de votre mot de passe de compte SP-Gestion.fr")    
    
    password_reset_url = edit_password_reset_url(user.perishable_token)
    
    content_type("multipart/alternative")
    part "text/plain" do |plain_part|
      plain_part.body = render_message("password_reset_instructions.plain", :password_reset_url => password_reset_url)
      plain_part.transfer_encoding = "base64"
    end

    part "text/html" do |html_part|
      html_part.body = render_message("password_reset_instructions.html", :password_reset_url => password_reset_url)
      html_part.transfer_encoding = "base64"
    end
  end
  
  def boost_activation(user)
    setup(user)
    subject("Activation de votre compte SP-Gestion.fr")

    confirmation_url = activate_url(user.perishable_token)

    content_type("multipart/alternative")
    part "text/plain" do |plain_part|
      plain_part.body = render_message("boost_activation.plain", :confirmation_url => confirmation_url)
      plain_part.transfer_encoding = "base64"
    end

    part "text/html" do |html_part|
      html_part.body = render_message("boost_activation.html", :confirmation_url => confirmation_url)
      html_part.transfer_encoding = "base64"
    end
  end  
  
  private

  def setup(user)
    default_url_options[:host] = "#{user.station.url}.#{BASE_URL}"
    from("SP-Gestion.fr <pas_de_reponse@sp-gestion.fr>")
    recipients(user.email)
    sent_on(Time.now)
  end

end
