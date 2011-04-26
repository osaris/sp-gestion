class AddIndexToUsers < ActiveRecord::Migration
  def self.up
    add_index(:users, :station_id)
  end

  def self.down
    remove_index(:users, :station_id)
  end
end