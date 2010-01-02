class BetaCode < ActiveRecord::Base
  
  belongs_to :user
  
  def after_initialize
    self.code ||= ActiveSupport::SecureRandom.hex(5)
    self.used ||= false
  end
  
end
