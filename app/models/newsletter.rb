class Newsletter < ActiveRecord::Base
  
  attr_accessible :email
  
  validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
  validates_uniqueness_of :email
  
  before_create :generate_activation_key
  after_save    :send_activation_email
  
  def validate!
    self.activated_at = Time.now
    self.activation_key.clear
    self.save!
  end
    
  private
  
  def generate_activation_key
    self.activation_key = rand_str(64)    
  end
  
  def send_activation_email
    #NewsletterMailer.deliver_activation_email(self)
  end
  
  def rand_str(len)
    Array.new(len/2) { rand(256) }.pack('C*').unpack('H*').first
  end  
  
end
