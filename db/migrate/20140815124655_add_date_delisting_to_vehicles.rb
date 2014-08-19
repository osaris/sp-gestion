class AddDateDelistingToVehicles < ActiveRecord::Migration
  def change
    add_column(:vehicles, :date_delisting, :date)
  end
end
