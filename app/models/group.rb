# -*- encoding : utf-8 -*-
class Group < ActiveRecord::Base

  belongs_to :station
  has_many :users

  validates_presence_of :name, :message => "Le nom est obligatoire."
end
