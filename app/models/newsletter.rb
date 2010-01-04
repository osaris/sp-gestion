class Newsletter < ActiveRecord::Base
  
  attr_accessible :email
  
  validates_format_of :email, :with => /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
  validates_uniqueness_of :email
  
  after_create  :send_activation_email
  
  def after_initialize
    # FIXME can't use self there because of Rails bug
    # https://rails.lighthouseapp.com/projects/8994/tickets/3165-activerecordmissingattributeerror-after-update-to-rails-v-234
    # this create 64 chars length string
    write_attribute(:activation_key, ActiveSupport::SecureRandom.hex(32)) unless read_attribute(:activation_key)
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
