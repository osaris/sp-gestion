class RemoveGeocodingTables < ActiveRecord::Migration
  def change
    drop_table(:geocodes)
    drop_table(:geocodings)
  end
end
