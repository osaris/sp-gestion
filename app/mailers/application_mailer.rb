# Basic mailer setup inherited by all specifics mailers
class ApplicationMailer < ActionMailer::Base

  default :from => 'SP-Gestion.fr <contact@sp-gestion.fr>'

end
