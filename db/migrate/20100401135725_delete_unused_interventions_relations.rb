class DeleteUnusedInterventionsRelations < ActiveRecord::Migration
  def self.up
    execute("DELETE FROM fireman_interventions
             WHERE NOT EXISTS (
              SELECT interventions.id
              FROM interventions
              WHERE interventions.id = fireman_interventions.intervention_id
             )")
    execute("DELETE FROM intervention_vehicles
            WHERE NOT EXISTS (
             SELECT vehicles.id
             FROM vehicles
             WHERE vehicles.id = intervention_vehicles.vehicle_id
            )")
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
