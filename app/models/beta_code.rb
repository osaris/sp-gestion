class BetaCode < ActiveRecord::Base
  
  belongs_to :user

  before_create :generate_code
  
  def initialize(params = nil)
    super
    self.used ||= false
  end

  private

  def generate_code
    self.code ||= ActiveSupport::SecureRandom.hex(5)
  end
  
end
