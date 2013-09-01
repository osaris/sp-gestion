class AddCheckupTruckToFiremen < ActiveRecord::Migration
  def change
    add_column(:firemen, :checkup_truck, :date)
  end
end
