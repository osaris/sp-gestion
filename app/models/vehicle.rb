class Vehicle < ActiveRecord::Base
  
  belongs_to :station
  has_many :intervention_vehicles
  has_many :interventions, :through => :intervention_vehicles
  
  validates_presence_of :name, :message => "Le nom est obligatoire."
    
end
