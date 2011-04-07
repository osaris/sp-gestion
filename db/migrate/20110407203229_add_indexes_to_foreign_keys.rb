class AddIndexesToForeignKeys < ActiveRecord::Migration
  def self.up
    add_index(:check_lists, :station_id)
    add_index(:convocation_firemen, :fireman_id)
    add_index(:convocation_firemen, :convocation_id)
    add_index(:convocations, :station_id)
    add_index(:fireman_interventions, :fireman_id)
    add_index(:fireman_interventions, :intervention_id)
    add_index(:firemen, :station_id)
    add_index(:grades, :fireman_id)
    add_index(:intervention_vehicles, :intervention_id)
    add_index(:interventions, :station_id)
    add_index(:items, :check_list_id)
    add_index(:messages, :user_id)
    add_index(:stations, :url)
    add_index(:uniforms, :station_id)
    add_index(:vehicles, :station_id)
  end

  def self.down
    remove_index(:vehicles, :station_id)
    remove_index(:uniforms, :station_id)
    remove_index(:stations, :url)
    remove_index(:messages, :user_id)
    remove_index(:items, :check_list_id)
    remove_index(:interventions, :station_id)
    remove_index(:intervention_vehicles, :intervention_id)
    remove_index(:grades, :fireman_id)
    remove_index(:firemen, :station_id)
    remove_index(:fireman_interventions, :intervention_id)
    remove_index(:fireman_interventions, :fireman_id)
    remove_index(:convocations, :station_id)
    remove_index(:convocation_firemen, :convocation_id)
    remove_index(:convocation_firemen, :fireman_id)
    remove_index(:check_lists, :station_id)
  end
end
