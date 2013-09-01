class AddIndexesForInterventionRoles < ActiveRecord::Migration
  def up
    add_index(:fireman_interventions, :intervention_role_id)
    add_index(:intervention_roles, :station_id)
  end
end
