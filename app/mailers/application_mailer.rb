# Basic mailer setup inherited by all specifics mailers
class ApplicationMailer < ActionMailer::Base

  default :from => 'SP-Gestion.fr <pas_de_reponse@sp-gestion.fr>'

end