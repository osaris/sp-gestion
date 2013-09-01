# -*- encoding : utf-8 -*-
class CreateGrades < ActiveRecord::Migration
  def self.up
    create_table :grades do |t|
      t.references(:fireman)
      t.integer(:kind)
      t.date(:date)
    end
  end

  def self.down
    drop_table :grades
  end
end
