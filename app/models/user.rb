# User used for auth
class User < ActiveRecord::Base

  belongs_to :station
  has_many :messages, :dependent => :destroy
  has_many :beta_codes
  
  attr_accessor :beta_code
  
  after_create :assign_beta_code
  
  acts_as_authentic do |config| 
    config.validations_scope = :station_id
    # only to be able to set the message
    config.validates_length_of_email_field_options(:within => 6..100, :message => "L'adresse email doit avoir au minimum 6 caractères.")
    config.validates_length_of_password_field_options(:minimum => 6, :message => "Le mot de passe doit avoir au moins 6 caractères.")
    # because we reset password on the same page as profile
    config.ignore_blank_passwords = true
    config.validates_confirmation_of_password_field_options(:message => "Le mot de passe ne correspond pas à la confirmation.")
  end
  
  def validate_on_create
    bc = BetaCode.find(:first, :conditions => {:code => self.beta_code, :used => false})
    self.errors.add(:beta_code, "Ce code n'est pas valide.") if bc.blank?
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
    self.beta_codes.each do |beta_code|
      beta_code.update_attribute(:used, true)
    end
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
  
  def boost_activation
    if self.confirmed_at.blank?
      UserMailer.deliver_boost_activation(self)
      update_attribute(:last_boosted_at, Time.now)
      return true
    else
      return false
    end
  end
  
  private
  
  def assign_beta_code
    bc = BetaCode.find(:first, :conditions => {:code => self.beta_code, :used => false})
    bc.update_attribute(:user_id, self.id)
  end

end
