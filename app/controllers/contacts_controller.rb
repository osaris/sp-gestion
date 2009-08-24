class ContactsController < ApplicationController
  
  def new
    @form_contact = FormContact.new
  end

  def create
    @form_contact = FormContact.new(params[:form_contact])
    if @form_contact.valid?
      ContactMailer.deliver_contact(@form_contact)
    else
      render(:action => 'new')
    end
  rescue Exception => ex
    logger.error "Impossible d'envoyer un email: #{ex.message}\nParams: #{params[:form_contact].inspect}"
    flash[:error] = "Erreur lors de l'envoi du message. Réessayez plus tard."
    render(:action => 'index')
  end  
  
end