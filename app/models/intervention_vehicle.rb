class InterventionVehicle < ActiveRecord::Base
  
  belongs_to :intervention
  belongs_to :vehicle
  
end
