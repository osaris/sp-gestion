class CreateInterventionRoles < ActiveRecord::Migration
  def change
    create_table :intervention_roles do |t|
      t.references(:station)
      t.string(:name)
      t.string(:short_name)
      t.timestamps
    end
  end
end
