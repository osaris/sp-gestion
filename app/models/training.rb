# -*- encoding : utf-8 -*-
class Training < ActiveRecord::Base

  attr_accessible :name, :short_name, :description

  belongs_to :station
  has_many :fireman_trainings
  has_many :firemen, :through => :fireman_trainings

  validates_presence_of :name, :message => "Le nom est obligatoire."
  validates_presence_of :short_name, :message => "Le nom court est obligatoire."

  before_destroy :check_associations

  scope :order_by_short_name, order('short_name')

  private

  def check_associations
    unless self.firemen.empty?
      self.errors[:base] << "Impossible de supprimer cette formation car elle a été effectuée par une ou plusieurs personnes." and return false
    end
  end

end
