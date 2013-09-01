# -*- encoding : utf-8 -*-
class AddLatitudeAndLongitudeToInterventions < ActiveRecord::Migration
  def self.up
    add_column(:interventions, :latitude, :float)
    add_column(:interventions, :longitude, :float)
  end

  def self.down
    remove_column(:interventions, :longitude)
    remove_column(:interventions, :latitude)
  end
end
