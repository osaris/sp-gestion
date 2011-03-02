# -*- encoding : utf-8 -*-
class AddOwnerIdToStation < ActiveRecord::Migration
  def self.up
    add_column(:stations, :owner_id, :integer)
    execute("UPDATE stations 
             SET owner_id = (
              SELECT users.id
              FROM users 
              WHERE users.station_id = stations.id
              ORDER BY users.id LIMIT 1)")
  end

  def self.down
    remove_column(:stations, :owner_id)
  end
end
