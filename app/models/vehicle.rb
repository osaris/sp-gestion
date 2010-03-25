# Used in interventions
class Vehicle < ActiveRecord::Base
  
  belongs_to :station
  has_many :intervention_vehicles
  has_many :interventions, :through => :intervention_vehicles
  
  validates_presence_of :name, :message => "Le nom est obligatoire."
  
  before_destroy :check_associations
  
  private
  
  def check_associations
    unless self.interventions.empty?
      self.errors.add_to_base("Impossible de supprimer ce véhicule car il a effectué des interventions.") and return false
    end
  end
end
