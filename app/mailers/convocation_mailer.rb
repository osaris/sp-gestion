# -*- encoding : utf-8 -*-
class ConvocationMailer < ApplicationMailer

  def convocation(convocation, convocation_fireman, user_email)
    default_url_options[:host] = "#{convocation.station.url}.#{BASE_URL}"

    # TODO pass fewer var to the view
    @fireman = convocation_fireman.fireman
    @grade = (convocation_fireman.grade.nil?||convocation.hide_grade) ? "" : Grade::GRADE.key(convocation_fireman.grade)
    @uniform = convocation.uniform
    @convocation = convocation
    @accept_url = accept_convocation_convocation_fireman_url(Digest::SHA1.hexdigest(convocation.id.to_s),
                                                             Digest::SHA1.hexdigest(convocation_fireman.id.to_s))

    mail(:to => @fireman.email,
         :from => @convocation.station.name + " <pas_de_reponse@sp-gestion.fr>",
         :reply_to => user_email,
         :subject => "Convocation")
  end

  def sending_confirmation(convocation, user_email)
    @convocation = convocation

    mail(:to => user_email,
         :subject => "Confirmation d'envoi de la convocation")
  end
end
