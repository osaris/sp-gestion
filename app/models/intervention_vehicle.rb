# Relation table for vehicle used in intervention
class InterventionVehicle < ActiveRecord::Base
  
  belongs_to :intervention
  belongs_to :vehicle
  
end
