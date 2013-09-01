class AddMissingIndexesToForeignKeys < ActiveRecord::Migration
  def change
    add_index(:convocations, :uniform_id)
    add_index(:fireman_trainings, :station_id)
    add_index(:intervention_vehicles, :vehicle_id)
    add_index(:taggings, :tagger_id)
    add_index(:taggings, :tagger_type)
  end
end
