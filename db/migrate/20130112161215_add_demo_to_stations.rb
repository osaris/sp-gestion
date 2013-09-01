class AddDemoToStations < ActiveRecord::Migration
  def change
    add_column(:stations, :demo, :boolean)
    Station.update_all(:demo => false)
  end
end
