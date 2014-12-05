# User relative notifications
class UserMailer < ApplicationMailer

  def confirmation_instructions(user)
    setup(user.station)

    @confirmation_url = edit_confirmation_url(user.perishable_token)

    mail(:to => user.email,
         :subject => "Activation de votre compte SP-Gestion.fr")
  end

  def cooptation_instructions(user)
    setup(user.station)

    @station_url = user.station_url
    @confirmation_url = edit_confirmation_url(user.perishable_token)

    mail(:to => user.email,
         :subject => "Invitation à rejoindre SP-Gestion.fr")
  end

  def password_reset_instructions(user)
    setup(user.station)

    @password_reset_url = edit_password_reset_url(user.perishable_token)

    mail(:to => user.email,
         :subject => "Modification de votre mot de passe de compte SP-Gestion.fr")
  end

  def new_email_instructions(user)
    setup(user.station)

    @new_email_url = edit_email_confirmation_url(user.perishable_token)

    mail(:to => user.new_email,
         :subject => "Changement de votre adresse email SP-Gestion.fr")
  end

  private

  def setup(station)
    default_url_options[:host] = "#{station.url}.#{Rails.configuration.base_url}"
  end

end
