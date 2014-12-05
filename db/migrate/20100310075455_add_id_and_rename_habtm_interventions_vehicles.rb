class AddIdAndRenameHabtmInterventionsVehicles < ActiveRecord::Migration
  def self.up
    rename_table :interventions_vehicles, :intervention_vehicles
    add_column :intervention_vehicles, :id, :primary_key
  end

  def self.down
    rename_table :intervention_vehicles, :interventions_vehicles
    remove_column :interventions_vehicles, :id
  end
end
