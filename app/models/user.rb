class User < ActiveRecord::Base

  belongs_to :station
  has_many :messages, :dependent => :delete_all
  belongs_to :group

  delegate :url, :to => :station, :prefix => true

  attr_accessor :new_email_tmp

  before_create :reset_perishable_token

  scope :confirmed, -> { where(['confirmed_at IS NOT NULL']) }

  validates_format_of :new_email_tmp, :with => Authlogic::Regex.email, :message => "L'adresse email est mal formée.", :allow_blank => true
  validates_length_of :new_email_tmp, :within => 6..100, :message => "L'adresse email doit avoir au minimum 6 caractères.", :allow_blank => true

  acts_as_authentic do |config|
    config.disable_perishable_token_maintenance = true
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
      :if => :password_validation_needed?,
      :minimum => 6,
      :message => "Le mot de passe doit avoir au moins 6 caractères."
    })
    config.validates_confirmation_of_password_field_options({
      :on => :update,
      :if => :password_validation_needed?,
      :message => "Le mot de passe ne correspond pas à la confirmation."
    })
    config.validates_length_of_password_confirmation_field_options({
      :on => :update,
      :if => :password_validation_needed?,
      :minimum => 6,
      :message => "Le mot de passe doit avoir au moins 6 caractères."
    })
  end

  acts_as_messageable

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
    save
  end

  def deliver_confirmation_instructions!
    self.reset_perishable_token!
    self.confirmed_at = nil
    self.confirmation_sent_at = Time.now.utc
    self.save(:validate => false)
    UserMailer.confirmation_instructions(self).deliver_later
  end

  def deliver_password_reset_instructions!
    self.reset_perishable_token!
    UserMailer.password_reset_instructions(self).deliver_later
  end

  def deliver_cooptation_instructions!
    self.reset_perishable_token!
    self.confirmed_at = nil
    self.confirmation_sent_at = Time.now.utc
    self.save(:validate => false)
    UserMailer.cooptation_instructions(self).deliver_later
  end

  def update_profile(params)
    email_already_used = false
    email_change = false
    if !params[:new_email_tmp].blank? and params[:new_email_tmp] != self.email
      nb_users_with_same_email = self.station
                                     .users
                                     .where(:email => params[:new_email_tmp])
                                     .count
      if nb_users_with_same_email == 0
        params[:new_email] = params[:new_email_tmp]
        email_change = true
      else
        self.errors[:new_email_tmp] << "L'adresse email souhaitée est déjà utilisée."
      end
    end

    if email_already_used
      result = false
    else
      result = self.update_attributes(params)
      deliver_new_email_instructions! if result and email_change
    end
    result
  end

  def swap_emails
    self.email = self.new_email
    self.new_email = nil
    save
  end

  def owner?
    self.id == self.station.owner_id
  end

  private

  def password_validation_needed?
    !group_id_changed? and (confirmed_at.blank? or (!password.nil? or !password_confirmation.nil?))
  end

  def deliver_new_email_instructions!
    self.reset_perishable_token!
    UserMailer.new_email_instructions(self).deliver_later
  end
end
