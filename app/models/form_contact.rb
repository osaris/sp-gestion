class FormContact < ActiveForm
  
  attr_accessor :name, :email, :subject, :message
  
  validates_presence_of :name, :email, :subject, :message
  validates_format_of :email,
                      :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                      :message => "L'adresse email doit être valide."
  
end