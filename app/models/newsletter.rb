class Newsletter < ActiveRecord::Base
  
  attr_accessible :email
  
  validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
  validates_uniqueness_of :email
  
  after_create  :send_activation_email
  
  def after_initialize
    self.activation_key ||= ActiveSupport::SecureRandom.hex(32) # this create 64 chars length string
  end
  
  def activate!
    self.activated_at = Time.now
    self.activation_key = ""
    self.save!
  end
  
  def to_param
    self.activation_key
  end
    
  private
  
  def send_activation_email
    NewsletterMailer.deliver_activation_instructions(self)
  end

end
