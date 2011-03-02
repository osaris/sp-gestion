# -*- encoding : utf-8 -*-
class ConvocationMailer < ApplicationMailer

  def convocation(convocation, convocation_fireman, user_email)
    @fireman = convocation_fireman.fireman
    @grade = (convocation_fireman.grade.nil?||convocation.hide_grade) ? "" : Grade::GRADE.key(convocation_fireman.grade)
    @uniform = convocation.uniform
    @convocation = convocation

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
