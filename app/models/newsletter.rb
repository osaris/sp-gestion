class Newsletter < ActiveRecord::Base
  
  attr_accessible :email
  
  validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
  validates_uniqueness_of :email

  before_create :generate_activation_key
  after_create  :send_activation_email
  
  named_scope :inactive, { :conditions => {:activated_at => nil} }
  named_scope :to_invite, { :conditions => ['activated_at IS NOT NULL AND invited_at IS NULL']}
  
  def activate!
    self.activated_at = Time.now
    self.activation_key = ""
    self.save!
  end
  
  def to_param
    self.activation_key
  end
  
  def invite_to_beta
    if self.activated_at.blank? or not(self.invited_at.blank?)
      return false
    else
      bc = BetaCode.create(:email => self.email)
      update_attribute(:invited_at, Time.now)
      return true
    end
  end
  
  def boost_activation
    if self.activated_at.blank?
      NewsletterMailer.deliver_boost_activation(self)
      update_attribute(:last_boosted_at, Time.now)
      return true
    else
      return false
    end
  end
    
  private

  def generate_activation_key
    self.activation_key = ActiveSupport::SecureRandom.hex(32)
  end

  def send_activation_email
    NewsletterMailer.deliver_activation_instructions(self)
  end

end
