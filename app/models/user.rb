class User < ActiveRecord::Base

  belongs_to :station
  has_many :messages
  
  acts_as_authentic do |c| 
    c.validations_scope = :station_id
    # only to be able to set the message
    c.validates_length_of_email_field_options(:within => 6..100, :message => "L'adresse email doit avoir au minimum 6 caractères.")
    c.validates_length_of_password_field_options(:minimum => 6, :message => "Le mot de passe doit avoir au moins 6 caractères.")
    # because we reset password on the same page as profile
    c.ignore_blank_passwords = true
    c.validates_confirmation_of_password_field_options(:message => "Le mot de passe ne correspond pas à la confirmation.")
  end
  
  def reset_password!(new_password, new_password_confirmation)
    self.password = new_password || ""
    self.password_confirmation = new_password_confirmation || ""
    self.save
  end
  
  def confirmed?
    !(self.new_record? || self.confirmed_at.nil?)
  end

  def confirm!
    update_attribute(:confirmed_at, Time.now.utc)
  end
  
  def deliver_confirmation_instructions!
    self.reset_perishable_token
    self.confirmed_at = nil
    self.confirmation_sent_at = Time.now.utc
    self.save(false)
    UserMailer.deliver_confirmation_instructions(self)
  end
    
  def deliver_password_reset_instructions!  
    reset_perishable_token!  
    UserMailer.deliver_password_reset_instructions(self)
  end

end
