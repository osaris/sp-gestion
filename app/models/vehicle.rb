# -*- encoding : utf-8 -*-
# Used in interventions
class Vehicle < ActiveRecord::Base

  belongs_to :station
  has_many :intervention_vehicles
  has_many :interventions, :through => :intervention_vehicles

  validates_presence_of :name, :message => "Le nom est obligatoire."
  # TODO use validates_date when https://github.com/adzap/validates_timeliness/issues/41 is fixed
  validates :date_approval, :timeliness => { :allow_blank => true, :type => :date }
  validates :date_check, :timeliness => { :allow_blank => true, :type => :date }
  validates :date_review, :timeliness => { :allow_blank => true, :type => :date }

  before_destroy :check_associations

  private

  def check_associations
    unless self.interventions.empty?
      self.errors[:base] << "Impossible de supprimer ce véhicule car il a effectué des interventions." and return false
    end
  end
end
