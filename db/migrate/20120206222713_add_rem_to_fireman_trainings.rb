class AddRemToFiremanTrainings < ActiveRecord::Migration
  def change
    add_column(:fireman_trainings, :rem, :text)
  end
end
