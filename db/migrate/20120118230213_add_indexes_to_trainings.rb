class AddIndexesToTrainings < ActiveRecord::Migration
  def change
    add_index(:trainings, :station_id)
    add_index(:fireman_trainings, :fireman_id)
    add_index(:fireman_trainings, :training_id)
  end
end