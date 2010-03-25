# Beta code linked to user for beta-test
class BetaCode < ActiveRecord::Base
  
  belongs_to :user

  before_create :generate_code
  after_create :send_welcome_email
  
  named_scope :unused, { :conditions => ['user_id IS NULL'] }
  named_scope :inactive, { :conditions => ['used = ? AND user_id IS NOT NULL', false] }
  named_scope :used, { :conditions => ['user_id IS NOT NULL AND used = ?', true]}  
  
  def initialize(params = nil)
    super
    self.used ||= false
  end
  
  def boost_activation
    if self.user_id.blank?
      BetaCodeMailer.deliver_boost_activation(self)
      update_attribute(:last_boosted_at, Time.now)
      return true
    else
      return false
    end
  end

  private

  def generate_code
    self.code ||= ActiveSupport::SecureRandom.hex(5)
  end
  
  def send_welcome_email
    BetaCodeMailer.deliver_welcome_instructions(self)
  end
  
end
