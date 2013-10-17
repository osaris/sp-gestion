# -*- encoding : utf-8 -*-
class InterventionVehicle < ActiveRecord::Base

  belongs_to :intervention
  belongs_to :vehicle

end
