class CreateFiremanTrainings < ActiveRecord::Migration
  def change
    create_table :fireman_trainings do |t|
      t.references(:fireman)
      t.references(:training)
      t.date(:achievement)
      t.timestamps
    end
  end
end