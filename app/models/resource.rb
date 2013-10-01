# -*- encoding : utf-8 -*-
class Resource < ActiveRecord::Base

  has_many :permissions, :dependent => :destroy
  has_many :groups, :through => :permissions
end
