class CreateInterventionsVehicles < ActiveRecord::Migration
  def self.up
    create_table :interventions_vehicles, :id => false do |t|
      t.references(:intervention)
      t.references(:vehicle)
      t.timestamps
    end
  end

  def self.down
    drop_table :interventions_vehicles
  end
end
