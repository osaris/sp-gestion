class CreateFiremanInterventions < ActiveRecord::Migration
  def self.up
    create_table :fireman_interventions do |t|
      t.references(:fireman)
      t.references(:intervention)
      t.integer(:grade)
      t.timestamps
    end
  end

  def self.down
    drop_table :fireman_interventions
  end
end
