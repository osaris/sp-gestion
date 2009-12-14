class Message < ActiveRecord::Base
  
  belongs_to :user
  
  named_scope :unread, :conditions => {:read => false}
  
  def mark_as_read
    update_attribute(:read, true) unless self.read
  end
  
end
