class AddRemColumnToVehicles < ActiveRecord::Migration
  def self.up
    add_column(:vehicles, :rem, :text)
  end

  def self.down
    remove_column(:vehicles, :rem)
  end
end
