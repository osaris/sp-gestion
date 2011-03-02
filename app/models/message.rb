# -*- encoding : utf-8 -*-
# Message used for internal notification system
class Message < ActiveRecord::Base

  belongs_to :user

  scope :unread, where(:read_at => nil)

  def read?
    !self.read_at.blank?
  end

  def read!
    update_attribute(:read_at, Time.now) unless self.read?
  end

end
