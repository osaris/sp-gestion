class AddInterventionsNumberSettingsToStations < ActiveRecord::Migration
  def change
    change_table :stations do |t|
      t.boolean :interventions_number_per_year, :default => false
      t.integer :interventions_number_size, :default => 0
    end
  end
end