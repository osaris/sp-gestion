class CreateInterventions < ActiveRecord::Migration
  def self.up
    create_table :interventions do |t|
      t.references(:station)
      t.integer(:kind)
      t.string(:number)
      t.datetime(:start_date)
      t.datetime(:end_date)
      t.string(:place)
      t.text(:rem)
      t.timestamps
    end
  end

  def self.down
    drop_table :interventions
  end
end
