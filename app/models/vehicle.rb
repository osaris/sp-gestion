# -*- encoding : utf-8 -*-
class Vehicle < ActiveRecord::Base

  belongs_to :station
  has_many :intervention_vehicles
  has_many :interventions, :through => :intervention_vehicles

  mount_uploader :vehicle_photo, VehiclePhotoUploader

  validates_presence_of :name, :message => "Le nom est obligatoire."
  validates_date :date_approval, :allow_blank => true
  validates_date :date_check, :allow_blank => true
  validates_date :date_review, :allow_blank => true

  before_destroy :check_associations

  private

  def check_associations
    unless self.interventions.empty?
      self.errors[:base] << "Impossible de supprimer ce véhicule car il a effectué des interventions." and return false
    end
  end
end