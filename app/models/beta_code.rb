class BetaCode < ActiveRecord::Base
  
  belongs_to :user
  
  before_save :generate_code
  
  def initialize(params = nil)
    super
    self.used ||= false
  end
  
  private
  
  def generate_code
    self.code ||= ActiveSupport::SecureRandom.base64(10)
  end
  
end
