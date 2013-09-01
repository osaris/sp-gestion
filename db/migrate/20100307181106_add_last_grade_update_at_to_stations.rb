# -*- encoding : utf-8 -*-
class AddLastGradeUpdateAtToStations < ActiveRecord::Migration
  def self.up
    add_column(:stations, :last_grade_update_at, :date)
    execute("UPDATE stations SET last_grade_update_at = (
              SELECT MAX(date) FROM grades
              INNER JOIN firemen ON (firemen.id = grades.fireman_id)
              WHERE firemen.station_id = stations.id
             )")
  end

  def self.down
    remove_column(:stations, :last_grade_update_at)
  end
end
