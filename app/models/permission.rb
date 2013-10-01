# -*- encoding : utf-8 -*-
class Permission < ActiveRecord::Base

  belongs_to :group
  belongs_to :resource
end
