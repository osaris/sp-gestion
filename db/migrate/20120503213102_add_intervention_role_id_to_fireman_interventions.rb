class AddInterventionRoleIdToFiremanInterventions < ActiveRecord::Migration
  def change
    add_column(:fireman_interventions, :intervention_role_id, :integer)
  end
end
