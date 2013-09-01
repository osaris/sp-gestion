class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.references(:station)
      t.string(:name)
      t.string(:short_name)
      t.text(:description)
      t.timestamps
    end
  end
end
