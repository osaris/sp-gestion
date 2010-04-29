# User used for auth
class User < ActiveRecord::Base

  belongs_to :station
  has_many :messages, :dependent => :destroy
  has_many :beta_codes
  
  attr_accessor :beta_code, :cooptation
  
  after_create :assign_beta_code
  
  named_scope :confirmed, :conditions => ['confirmed_at IS NOT NULL']
  
  acts_as_authentic do |config| 
    config.validations_scope = :station_id
    
    # email validation rules
    config.validates_length_of_email_field_options({
      :within => 6..100, :message => "L'adresse email doit avoir au minimum 6 caractères."
    })
    config.validates_uniqueness_of_email_field_options({
      :if => Proc.new {|user| user.attribute_present?('email') && user.email_changed?},
      :case_sensitive => false,
      :scope => validations_scope,
      :message => "Un utilisateur avec cette adresse email existe déjà pour ce compte."
    })    
    
    # password validation rules
    config.validates_length_of_password_field_options({
      :on => :update,
      :minimum => 6, :message => "Le mot de passe doit avoir au moins 6 caractères."
    })
    config.validates_confirmation_of_password_field_options({
      :on => :update,
      :message => "Le mot de passe ne correspond pas à la confirmation."
    })
    config.validates_length_of_password_confirmation_field_options({
      :on => :update,
      :minimum => 6, :message => "Le mot de passe doit avoir au moins 6 caractères."
    })
    
    # because we reset password on the same page as profile
    config.ignore_blank_passwords = true
  end
  
  def validate_on_create
    unless cooptation
      bc = BetaCode.find(:first, :conditions => {:code => self.beta_code, :used => false})
      self.errors.add(:beta_code, "Ce code n'est pas valide.") if bc.blank?
    end
  end
  
  def reset_password!(new_password, new_password_confirmation)
    self.password = new_password || ""
    self.password_confirmation = new_password_confirmation || ""
    self.save
  end
  
  def confirmed?
    !(self.new_record? || self.confirmed_at.nil?)
  end

  def confirm!(password, password_confirmation)
    self.confirmed_at = Time.now.utc
    self.password = password
    self.password_confirmation = password_confirmation
    result = save
    if result
      self.beta_codes.each do |beta_code|
        beta_code.update_attribute(:used, true)
      end      
    end
    result
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
  
  # for cooptation
  def deliver_cooptation_instructions!
    self.reset_perishable_token
    self.confirmed_at = nil
    self.confirmation_sent_at = Time.now.utc
    self.save(false)
    UserMailer.deliver_cooptation_instructions(self)
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
    unless cooptation
      bc = BetaCode.find(:first, :conditions => {:code => self.beta_code, :used => false})
      bc.update_attribute(:user_id, self.id)
    end
  end

end
