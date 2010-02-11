class BetaCode < ActiveRecord::Base
  
  belongs_to :user

  before_create :generate_code
  after_create :send_welcome_email
  
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
