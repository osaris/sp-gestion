class AddDatesColumnsToVehicles < ActiveRecord::Migration
  def self.up
    add_column(:vehicles, :date_approval, :date)
    add_column(:vehicles, :date_check, :date)
    add_column(:vehicles, :date_review, :date)
  end

  def self.down
    remove_column(:vehicles, :date_review)
    remove_column(:vehicles, :date_check)
    remove_column(:vehicles, :date_approval)
  end
end
