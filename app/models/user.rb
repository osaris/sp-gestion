# User used for auth
class User < ActiveRecord::Base

  belongs_to :station
  has_many :messages, :dependent => :destroy
  has_many :beta_codes
  
  attr_accessor :beta_code, :cooptation, :new_email_tmp
  
  after_create :assign_beta_code
  after_update :deliver_new_email_instructions
  
  named_scope :confirmed, :conditions => ['confirmed_at IS NOT NULL']
  
  validates_format_of :new_email_tmp, :with => Authlogic::Regex.email, :message => "L'adresse email est mal formée.", :allow_blank => true
  validates_length_of :new_email_tmp, :within => 6..100, :message => "L'adresse email doit avoir au minimum 6 caractères.", :allow_blank => true
  
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
      :on => :update, :if => :password_validation_needed?,
      :minimum => 6, :message => "Le mot de passe doit avoir au moins 6 caractères."
    })
    config.validates_confirmation_of_password_field_options({
      :on => :update, :if => :password_validation_needed?,
      :message => "Le mot de passe ne correspond pas à la confirmation."
    })
    config.validates_length_of_password_confirmation_field_options({
      :on => :update, :if => :password_validation_needed?,
      :minimum => 6, :message => "Le mot de passe doit avoir au moins 6 caractères."
    })
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
  
  def update_profile(params)
    if !params[:user][:new_email_tmp].blank? and params[:user][:new_email_tmp] != self.email
      already_used = self.station.users.find_by_email(params[:user][:new_email_tmp])
      if already_used
        self.errors.add(:new_email_tmp, "L'adresse email souhaitée est déjà utilisée.")
      else
        params[:user][:new_email] = params[:user][:new_email_tmp]
      end
    else
      already_used = false
    end
    
    already_used ? false : self.update_attributes(params[:user])
  end
  
  def swap_emails
    self.email = self.new_email
    self.new_email = nil
    save
  end
  
  private
  
  def password_validation_needed?
    confirmed_at.blank? or (!password.blank? or !password_confirmation.blank?)
  end
  
  def assign_beta_code
    unless cooptation
      bc = BetaCode.find(:first, :conditions => {:code => self.beta_code, :used => false})
      bc.update_attribute(:user_id, self.id)
    end
  end
  
  def deliver_new_email_instructions
    unless new_email.blank?
      self.reset_perishable_token
      UserMailer.deliver_new_email_instructions(self)
    end
  end

end
