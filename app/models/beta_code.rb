class BetaCode < ActiveRecord::Base
  
  belongs_to :user

  before_create :generate_code
  after_create :send_welcome_email
  
  named_scope :unused, { :conditions => ['user_id IS NULL'] }
  named_scope :inactive, { :conditions => { :used => false } }  
  
  def initialize(params = nil)
    super
    self.used ||= false
  end

  private

  def generate_code
    self.code ||= ActiveSupport::SecureRandom.hex(5)
  end
  
  def send_welcome_email
    BetaCodeMailer.deliver_welcome_instructions(self)
  end
  
end
