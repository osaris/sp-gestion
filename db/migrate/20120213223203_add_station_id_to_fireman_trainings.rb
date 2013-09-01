class AddStationIdToFiremanTrainings < ActiveRecord::Migration
  def change
    add_column(:fireman_trainings, :station_id, :integer)
  end
end
