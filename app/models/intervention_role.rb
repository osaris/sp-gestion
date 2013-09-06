# -*- encoding : utf-8 -*-
class InterventionRole < ActiveRecord::Base

  belongs_to :station
  has_many :fireman_intervention

  validates_presence_of :name, :message => "Le nom est obligatoire."
  validates_presence_of :short_name, :message => "Le nom court est obligatoire."

  before_destroy :check_associations

   private

  def check_associations
    unless self.fireman_intervention.empty?
      self.errors[:base] << "Impossible de supprimer ce rôle car il est attribué à des personnes en intervention." and return false
    end
  end
end
