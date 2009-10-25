class Newsletter < ActiveRecord::Base
  
  attr_accessible :email
  
  validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
  validates_uniqueness_of :email
  
  before_create :generate_activation_key
  after_create  :send_activation_email
  
  def activate!
    self.activated_at = Time.now
    self.activation_key = ""
    self.save!
  end
  
  def to_param
    self.activation_key
  end
    
  private
  
  def generate_activation_key
    self.activation_key = SecureRandom.hex(64)
  end
  
  def send_activation_email
    NewsletterMailer.deliver_activation_instructions(self)
  end

end
